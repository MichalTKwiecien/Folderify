/*
This file should be auto-generated using for example SwiftGen.
*/

import Foundation

enum Localizable {
    static let folderify = translation(for: "folderify")
    static let login = translation(for: "login")
    static let password = translation(for: "password")
}

private func translation(for key: String) -> String {
    Bundle.module.localizedString(forKey: key, value: nil, table: "Localizable")
}
