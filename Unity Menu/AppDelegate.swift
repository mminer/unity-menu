import AppKit
import HotKey

@main
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let hotKey = HotKey(key: .u, modifiers: [.control, .option, .command])
    private let menuBarManager = MenuBarManager()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        hotKey.keyDownHandler = menuBarManager.openMenu
    }
}
