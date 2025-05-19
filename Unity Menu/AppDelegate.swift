import AppKit
import KeyboardShortcuts

@main
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let menuBarManager = MenuBarManager()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        KeyboardShortcuts.onKeyUp(for: .openMenu, action: menuBarManager.openMenu)
    }
}
