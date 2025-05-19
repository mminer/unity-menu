import AppKit
import KeyboardShortcuts
import SwiftUI

extension KeyboardShortcuts.Name {
    static let openMenu = Self("openMenu")
}

private struct SettingsView: View {
    var body: some View {
        Form {
            KeyboardShortcuts.Recorder("Open Menu:", name: .openMenu)
        }
        .frame(width: 300)
        .padding()
    }
}

private var settingsWindow: NSWindow?

func showSettingsWindow() {
    if settingsWindow == nil {
        let view = SettingsView()
        let hostingController = NSHostingController(rootView: view)
        settingsWindow = NSWindow(contentViewController: hostingController)
        settingsWindow?.title = "Unity Menu Settings"
    }

    NSApplication.shared.activate(ignoringOtherApps: true)
    settingsWindow?.orderFrontRegardless()
}
