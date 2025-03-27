import ArgumentParser

struct UnityMenuCLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "unity-menu",
        abstract: "Open running Unity projects."
    )

    @Argument(help: "Unity project selection.")
    var selection: Int? = nil

    func run() throws {
        let unityProcesses = getUnityProcesses()
        let productNames = unityProcesses.map(\.productName)

        guard let selection = selection ?? promptForSelection(productNames: productNames),
              selection > 0, selection <= unityProcesses.count else {
            print("Invalid selection.")
            UnityMenuCLI.exit(withError: ExitCode.failure)
        }

        let processIdentifier = unityProcesses[selection - 1].processIdentifier
        openUnityProject(processIdentifier: processIdentifier)
    }
}

private func promptForSelection(productNames: [String]) -> Int? {
    for (index, productName) in productNames.enumerated() {
        print("[\(index + 1)]", productName)
    }

    print("Selection:", terminator: " ")

    guard let input = readLine() else {
        return nil
    }

    return Int(input)
}

UnityMenuCLI.main()
