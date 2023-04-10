/*
This file should be auto-generated using for example SwiftGen.
*/

import Foundation

enum Localizable {
    static let folderify = translation(for: "folderify")
    static let login = translation(for: "login")
    static let password = translation(for: "password")
    static let loginErrorTitle = translation(for: "login.error.title")
    static let loginErrorContent = translation(for: "login.error.content")
    static let loginErrorCTA = translation(for: "login.error.cta")
}

private func translation(for key: String) -> String {
    Bundle.module.localizedString(forKey: key, value: nil, table: "Localizable")
}
