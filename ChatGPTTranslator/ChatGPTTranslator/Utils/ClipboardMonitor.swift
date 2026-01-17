import Foundation
import AppKit

class ClipboardMonitor: ObservableObject {
    @Published var latestImage: NSImage?

    private var timer: Timer?
    private var lastChangeCount: Int = 0

    func startMonitoring() {
        lastChangeCount = NSPasteboard.general.changeCount

        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.checkClipboard()
        }
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }

    private func checkClipboard() {
        let pasteboard = NSPasteboard.general

        // 检查剪贴板是否有变化
        guard pasteboard.changeCount != lastChangeCount else {
            return
        }

        lastChangeCount = pasteboard.changeCount

        // 检查是否有图片
        if let image = getImageFromPasteboard() {
            DispatchQueue.main.async {
                self.latestImage = image
            }
        }
    }

    private func getImageFromPasteboard() -> NSImage? {
        let pasteboard = NSPasteboard.general

        // 尝试多种图片类型
        if let imageData = pasteboard.data(forType: .tiff),
           let image = NSImage(data: imageData) {
            return image
        }

        if let imageData = pasteboard.data(forType: .png),
           let image = NSImage(data: imageData) {
            return image
        }

        if pasteboard.canReadObject(forClasses: [NSImage.self], options: nil),
           let image = pasteboard.readObjects(forClasses: [NSImage.self], options: nil)?.first as? NSImage {
            return image
        }

        return nil
    }

    deinit {
        stopMonitoring()
    }
}
