import AppKit

class MenuBarManager: NSObject, NSMenuDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    override init() {
        super.init()
        statusItem.button?.image = NSImage(systemSymbolName: "gear", accessibilityDescription: "Unity Menu")
        statusItem.menu = NSMenu()
        statusItem.menu?.delegate = self
    }

    func menuWillOpen(_ menu: NSMenu) {
        menu.removeAllItems()

        var items = getUnityProcesses().enumerated().map { index, unityProcess in
            let keyEquivalent = index < 9 ? "\(index + 1)" : ""
            let item = NSMenuItem(title: unityProcess.productName, action: #selector(onOpenUnityProject), keyEquivalent: keyEquivalent)
            item.representedObject = unityProcess.processIdentifier
            return item
        }

        if !items.isEmpty {
            items.append(NSMenuItem.separator())
        }

        let unityHubItem = NSMenuItem(title: "Unity Hub", action: #selector(onOpenUnityHub), keyEquivalent: "h")
        unityHubItem.isEnabled = isUnityHubInstalled()
        items.append(unityHubItem)

        items.append(NSMenuItem.separator())
        items.append(NSMenuItem(title: "Quit Unity Menu", action: #selector(onQuit), keyEquivalent: "q"))

        for item in items {
            item.target = self
            menu.addItem(item)
        }
    }

    @objc func onOpenUnityHub() {
        openUnityHub()
    }

    @objc func onOpenUnityProject(item: NSMenuItem) {
        guard let processIdentifier = item.representedObject as? Int else {
            return
        }

        openUnityProject(processIdentifier: processIdentifier)
    }

    @objc func onQuit() {
        NSApplication.shared.terminate(self)
    }
}
