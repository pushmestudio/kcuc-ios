#!/usr/bin/env xcrun --sdk macosx swift

import Foundation

let version = "1.1"
var debug = false

// MARK: Exit status code
enum ExitCode: Int32 {
    case success = 0
    case failure
    case licenseNotFound
    case invalidPlist
    case generateError

    var reason: String {
        switch self {
            case .success: return "Generated!"
            case .failure: return "Finished with failure."
            case .licenseNotFound: return "Libraries not found"
            case .invalidPlist: return "Plist binary is broken.. something wrong."
            case .generateError: return "could not save plist in given path."
        }
    }
}

enum Options: String {
    case help = "--help"
    case verbose = "--verbose"
    case version = "--version"
}

// MARK: - Global Functions
func usage() {
    print("Usage: ./acknowledgement_generator.swift <Project Root Path> <Plist Output Path> (Options)")
}

func debugLog(_ message: @autoclosure () -> String) {
    _ = debug ? print("\(message())") : ()
}

// MARK: Common constants
struct Constants {
    private init() {}
    static let cocoaPodsDirName = "Pods"
    static let cocoaPodsDir = "\(cocoaPodsDirName)"
    static let carthageDirName = "Carthage"
    static let carthageDir = "\(carthageDirName)/Checkouts"
    static let directoryOtions: FileManager.DirectoryEnumerationOptions = [.skipsPackageDescendants, .skipsHiddenFiles]
    static let licenseMatchPatterns: [String] = ["LICENSE", "LICENCE"]
}

struct License {
    let title: String
    let text: String

    init?(url: URL) {
        guard let title = Helper.getLibraryName(from: url) else {
            print("invalid title: \(url)")
            return nil
        }
        guard let text = try? String(contentsOf: url, encoding: String.Encoding.utf8) else {
            print("invalid title: \(url)")
            return nil
        }
        self.title = title
        self.text = text
    }
}

final class Helper {
    private init() {}

    static func getLicenses() -> [License] {
        return self
        .getFilrURLs()
        .filter(Helper.isLicenseFileURL)
        .flatMap(License.init)
    }

    private static func getFileURLsFromLibraryDirectory(_ dir: String) -> [URL] {
        let result: [URL] = {
            let fileManager = FileManager.default
            return URL(string: "\(fileManager.currentDirectoryPath)/\(dir)").flatMap { (url: URL) -> FileManager.DirectoryEnumerator? in
                fileManager.enumerator(at: url, includingPropertiesForKeys: nil, options: Constants.directoryOtions, errorHandler: nil)
            }.flatMap { (enumerator: FileManager.DirectoryEnumerator) -> [URL]? in
                return enumerator.allObjects as? [URL]
            } ?? []
        }()
        return result
    }

    private static func getFilrURLs() -> [URL] {
        let cocoaPodsURLs = getFileURLsFromLibraryDirectory(Constants.cocoaPodsDir)
        let carthageURLs = getFileURLsFromLibraryDirectory(Constants.carthageDir)
        let result: [URL] = cocoaPodsURLs + carthageURLs
        return result
    }

    private static func isLicenseFileURL(url: URL) -> Bool {
        return Constants.licenseMatchPatterns.filter { url.lastPathComponent.range(of: $0) != nil  }.count == 1
    }

    static func getLibraryName(from url: URL) -> String? {
        if let index = url.pathComponents.index(of: Constants.cocoaPodsDirName) {
            return url.pathComponents.dropFirst(index + 1).first
        }

        if let index = url.pathComponents.index(of: Constants.carthageDirName) {
            return url.pathComponents.dropFirst(index + 2).first
        }
        return nil
    }

    static func escape(_ text: String) -> String {
        return text
        .replacingOccurrences(of: "<", with: "&lt;")
        .replacingOccurrences(of: ">", with: "&gt;")
    }
}

final class PlistExporter {
    private init() {}

    private static let Header = [
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
    "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">",
    "<plist version=\"1.0\">",
    "<dict>",
    "\t<key>PreferenceSpecifiers</key>",
    "\t<array>"
    ].joined(separator: "\n")

    private static let Footer = [
    "\t</array>",
    "\t<key>StringsTable</key>",
    "\t<string>Acknowledgements</string>",
    "\t<key>Title</key>",
    "\t<string>Acknowledgements</string>",
    "</dict>",
    "</plist>"
    ].joined(separator: "\n")

    static func export(with licenses: [License]) -> String {
        var string = ""
        string += self.Header + "\n"
        string += self.defaultElement() + "\n"
        string += licenses.map(self.createElement).joined(separator: "\n") + "\n"
        string += self.Footer
        return string
    }

    private static func createElement(title: String, text: String) -> String {
        return [
        "\t\t<dict>",
        "\t\t\t<key>FooterText</key>",
        "\t\t\t<string>\(Helper.escape(text))</string>",
        "\t\t\t<key>Title</key>",
        "\t\t\t<string>\(Helper.escape(title))</string>",
        "\t\t\t<key>Type</key>",
        "\t\t\t<string>PSGroupSpecifier</string>",
        "\t\t</dict>",
        ].joined(separator: "\n")
    }

    static func defaultElement() -> String {
        let title = "Acknowledgements"
        let text = "This application makes use of the following third party libraries:"
        return self.createElement(title: title, text: text)
    }

    static func createElement(from license: License) -> String {
        return self.createElement(title: license.title, text: license.text)
    }
}

// MARK: main

func main(rootPath: String, outputPath: String) -> ExitCode {
    let fileManager = FileManager.default
    fileManager.changeCurrentDirectoryPath(rootPath)
    debugLog("Root path: \(fileManager.currentDirectoryPath)")
    let licenses: [License] = Helper.getLicenses()

    if licenses.count == 0 { return .licenseNotFound }

    debugLog("Found \(licenses.count) libraries. \n\(licenses.map { $0.title })")

    let plist = PlistExporter.export(with: licenses)
    guard let plistData = plist.data(using: String.Encoding.utf8) else {
        return .invalidPlist
    }

    guard let _ = try? plistData.write(to: URL(fileURLWithPath: outputPath), options: .atomic) else {
        return .generateError
    }
    return .success
}

//-----------------------------------------------------------------------------
// MARK: - main
var args = Array(CommandLine.arguments.dropFirst())

if let _ = args.index(of: Options.version.rawValue) {
    print("Version: \(version)")
    exit(ExitCode.success.rawValue)
}

if let _ = args.index(of: Options.help.rawValue) {
    usage()
    exit(ExitCode.success.rawValue)
}

if let index = args.index(of: Options.verbose.rawValue) {
    print("debug enabled.")
    debug = true
    args.remove(at: index)
}

if args.count != 2 {
    print("Need 2 arguments. ", separator: "", terminator: "")
    usage()
    exit(ExitCode.failure.rawValue)
}

debugLog("args: \(args)")

let exitCode = main(rootPath: args[0], outputPath: args[1])

debugLog("[code: \(exitCode.rawValue)] \(exitCode.reason)")
exit(exitCode.rawValue)
