import SwiftUI
import Foundation

// Every request is intercepted locally. No text is sent to a translation service.
final class FixtureProtocol: URLProtocol {
    private static let lock = NSLock()
    private static var seen: [String] = []
    private var pending: DispatchWorkItem?

    static func reset() { lock.lock(); seen = []; lock.unlock() }
    static func requests() -> [String] { lock.lock(); defer { lock.unlock() }; return seen }
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        let text = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)?.queryItems?.first(where: { $0.name == "q" })?.value ?? ""
        Self.lock.lock(); Self.seen.append(text); Self.lock.unlock()
        let item = DispatchWorkItem { [self] in
            let data = try! JSONSerialization.data(withJSONObject: [[["translated-" + text]]])
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type": "application/json"])!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }
        pending = item
        DispatchQueue.main.asyncAfter(deadline: .now() + (text == "old" ? 0.30 : 0.01), execute: item)
    }
    override func stopLoading() { pending?.cancel() }
}

@main struct TranslationServiceTests {
    @MainActor static func waitForRequest() async {
        for _ in 0..<100 {
            if !FixtureProtocol.requests().isEmpty { return }
            try? await Task.sleep(nanoseconds: 10_000_000)
        }
        preconditionFailure("fixture request did not start")
    }

    @MainActor static func main() async {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [FixtureProtocol.self]
        let session = URLSession(configuration: configuration)
        defer { session.invalidateAndCancel() }

        FixtureProtocol.reset()
        let debounced = EnhancedTranslationService(session: session, debounceDelay: 0.10)
        let first = Task { await debounced.translateRealtime(text: "old", from: "en", to: "zh-CN") }
        try? await Task.sleep(nanoseconds: 20_000_000)
        let second = Task { await debounced.translateRealtime(text: "new", from: "en", to: "zh-CN") }
        let firstValue = await first.value
        let secondValue = await second.value
        precondition(firstValue == nil && secondValue == "translated-new")
        precondition(FixtureProtocol.requests() == ["new"])
        print("PASS rapid input sends only the latest text")

        FixtureProtocol.reset()
        let service = EnhancedTranslationService(session: session, debounceDelay: 0)
        let old = Task { await service.translateRealtime(text: "old", from: "en", to: "zh-CN") }
        await waitForRequest()
        let newer = Task { await service.translateRealtime(text: "new", from: "en", to: "zh-CN") }
        let oldValue = await old.value
        let newValue = await newer.value
        precondition(oldValue == nil && newValue == "translated-new")
        precondition(!service.isTranslating && service.errorMessage == nil)
        print("PASS in-flight stale translation is discarded")

        FixtureProtocol.reset()
        let clearing = Task { await service.translateRealtime(text: "old", from: "en", to: "zh-CN") }
        await waitForRequest()
        service.cancelTranslation()
        let clearedValue = await clearing.value
        precondition(clearedValue == nil && !service.isTranslating && service.errorMessage == nil)
        print("PASS clear cancels in-flight work without a stale error")

        FixtureProtocol.reset()
        let cancelled = Task { await debounced.translateRealtime(text: "old", from: "en", to: "zh-CN") }
        try? await Task.sleep(nanoseconds: 20_000_000)
        cancelled.cancel()
        let cancelledValue = await cancelled.value
        precondition(cancelledValue == nil && FixtureProtocol.requests().isEmpty)
        print("PASS caller cancellation cancels the owned task")

        FixtureProtocol.reset()
        let blanked = Task { await debounced.translateRealtime(text: "old", from: "en", to: "zh-CN") }
        try? await Task.sleep(nanoseconds: 20_000_000)
        let blank = await debounced.translateRealtime(text: " ", from: "en", to: "zh-CN")
        let blankedValue = await blanked.value
        precondition(blank == nil && blankedValue == nil && FixtureProtocol.requests().isEmpty)
        print("PASS blank input invalidates pending translation")
        print("5 tests passed; all network requests used local fixtures")
    }
}
