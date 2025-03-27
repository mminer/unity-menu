import Foundation

/// Lists processes currently running on the system.
func getProcesses() -> [(processIdentifier: Int, command: String)] {
    let pipe = Pipe()
    let task = Process()
    task.launchPath = "/bin/ps"
    task.arguments = ["x", "-o", "pid=,command="]
    task.standardOutput = pipe

    do {
        try task.run()
    } catch {
        print("Error listing processes:", error)
        return []
    }

    let data = pipe.fileHandleForReading.readDataToEndOfFile()

    guard let output = String(data: data, encoding: .utf8) else {
        print("Failed to read process list.")
        return []
    }

    return output.components(separatedBy: .newlines).compactMap { line in
        let components = line.split(separator: " ", maxSplits: 1)

        guard components.count == 2, let processIdentifier = Int(components[0]) else {
            return nil
        }

        let command = String(components[1])
        return (processIdentifier, command)
    }
}
