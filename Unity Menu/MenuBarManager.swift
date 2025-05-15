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
            let item = NSMenuItem(title: unityProcess.productName, action: #selector(onOpenUnityProject), keyEquivalent: keyEquivalent)
            item.representedObject = unityProcess.processIdentifier
            return item
        }

        if !items.isEmpty {
            items.append(NSMenuItem.separator())
        }

        items.append(NSMenuItem(title: "Unity Hub", action: #selector(onOpenUnityHub), keyEquivalent: "h"))
        items.append(NSMenuItem.separator())
        items.append(NSMenuItem(title: "Quit Unity Menu", action: #selector(onQuit), keyEquivalent: "q"))

        for item in items {
            item.target = self
            menu.addItem(item)
        }
    }

    func openMenu()
    {
        statusItem.button?.performClick(self)
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
