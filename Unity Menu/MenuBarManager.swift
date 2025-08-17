import AppKit

final class MenuBarManager: NSObject, NSMenuDelegate {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override init() {
        super.init()

        let iconImage = NSImage(named: "MenuBarIcon")
        iconImage?.isTemplate = true
        statusItem.button?.image = iconImage

        statusItem.menu = NSMenu()
        statusItem.menu?.delegate = self
    }

    func menuWillOpen(_ menu: NSMenu) {
        menu.removeAllItems()

        var items = getUnityProcesses().enumerated().map { index, unityProcess in
            let keyEquivalent = index < 9 ? "\(index + 1)" : ""
            let item = NSMenuItem(title: unityProcess.productName, action: #selector(onUnityProject), keyEquivalent: keyEquivalent)
            item.representedObject = unityProcess.processIdentifier
            item.toolTip = unityProcess.projectPath
            return item
        }

        if !items.isEmpty {
            items.append(NSMenuItem.separator())
        }

        items += [
            NSMenuItem(title: "Unity Hub", action: #selector(onUnityHub), keyEquivalent: "h"),
            NSMenuItem.separator(),
            NSMenuItem(title: "Settings...", action: #selector(onSettings), keyEquivalent: ","),
            NSMenuItem.separator(),
            NSMenuItem(title: "Quit Unity Menu", action: #selector(onQuit), keyEquivalent: "q"),
        ]

        for item in items {
            item.target = self
            menu.addItem(item)
        }
    }

    func openMenu()
    {
        statusItem.button?.performClick(self)
    }

    @objc func onQuit() {
        NSApplication.shared.terminate(self)
    }
    
    @objc func onSettings() {
        showSettingsWindow()
    }

    @objc func onUnityHub() {
        openUnityHub()
    }

    @objc func onUnityProject(item: NSMenuItem) {
        guard let processIdentifier = item.representedObject as? Int else {
            return
        }

        openUnityProject(processIdentifier: processIdentifier)
    }
}
