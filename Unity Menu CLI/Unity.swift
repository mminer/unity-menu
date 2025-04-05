import AppKit

/// Lists Unity processes currently running on the system.
func getUnityProcesses() -> [(processIdentifier: Int, productName: String)] {
    return getProcesses()
        .compactMap { processIdentifier, command -> (processIdentifier: Int, productName: String)? in
            guard let projectPath = getUnityProjectPath(from: command) else {
                return nil
            }

            let productName = getUnityProductName(projectPath: projectPath)
            return (processIdentifier, productName)
        }
        .sorted { $0.productName < $1.productName }
}

func openUnityHub() {
    guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.unity3d.unityhub") else {
        print("Failed to open Unity Hub.")
        return
    }

    print("Opening Unity Hub.")
    NSWorkspace.shared.openApplication(at: url, configuration: .init(), completionHandler: nil)
}

func openUnityProject(processIdentifier: Int) {
    guard let targetApplication = NSWorkspace.shared.runningApplications.first(where: { $0.processIdentifier == processIdentifier }) else {
        print("Failed to find application with process ID:", processIdentifier)
        return
    }

    print("Opening Unity project.")
    NSApplication.shared.yieldActivation(to: targetApplication)
    targetApplication.activate(options: [.activateAllWindows])
}

/// Reads a Unity project's product name from its ProjectSettings.asset file.
private func getUnityProductName(projectPath: String) -> String {
    let projectPathURL = URL(fileURLWithPath: projectPath)
    let projectSettingsPath = projectPathURL.appendingPathComponent("ProjectSettings/ProjectSettings.asset").path

    guard let projectSettings = try? String(contentsOfFile: projectSettingsPath, encoding: .utf8) else {
        return projectPathURL.lastPathComponent
    }

    let lines = projectSettings.components(separatedBy: .newlines)
    let productNamePrefix = "  productName: "

    guard let productNameLine = lines.first(where: { $0.hasPrefix(productNamePrefix) }) else {
        return projectPathURL.lastPathComponent
    }

    return String(productNameLine.dropFirst(productNamePrefix.count))
}

/// Extracts the project path from the command that Unity Hub used to launch the project.
private func getUnityProjectPath(from command: String) -> String? {
    // Example command that Unity Hub uses to launch a project:
    // /Applications/Unity/Hub/Editor/6000.0.36f1/Unity.app/Contents/MacOS/Unity -projectpath /Users/matthew/MyProject -useHub ...
    // Relying on this format is fragile and may break in future versions of Unity Hub.
    // TODO: Find more robust way to get the project path of running Unity projects.
    guard let match = command.firstMatch(of: /-projectpath (.+) -useHub/) else {
        return nil
    }

    return String(match.1)
}
