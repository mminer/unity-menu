import AppKit
import KeyboardShortcuts
import ServiceManagement
import SwiftUI

extension KeyboardShortcuts.Name {
    static let openMenu = Self("openMenu")
}

private struct SettingsView: View {
    @State private var launchAtLogin = SMAppService.mainApp.status == .enabled

    var body: some View {
        Form {
            KeyboardShortcuts.Recorder("Open menu:", name: .openMenu)
            Toggle("Launch at login", isOn: $launchAtLogin)
                .onChange(of: launchAtLogin) { _, newValue in
                    if newValue {
                        try? SMAppService.mainApp.register()
                    } else {
                        try? SMAppService.mainApp.unregister()
                    }
                }
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
