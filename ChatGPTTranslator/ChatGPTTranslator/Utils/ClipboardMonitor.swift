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

        // Check if the clipboard has changed
        guard pasteboard.changeCount != lastChangeCount else {
            return
        }

        lastChangeCount = pasteboard.changeCount

        // Check if there is a picture
        if let image = getImageFromPasteboard() {
            DispatchQueue.main.async {
                self.latestImage = image
            }
        }
    }

    private func getImageFromPasteboard() -> NSImage? {
        let pasteboard = NSPasteboard.general

        // Try multiple image types
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
