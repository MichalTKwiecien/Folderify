/*
This file should be auto-generated using for example SwiftGen.
*/

import Foundation

enum Localizable {
    static let folderViewErrorTitle = translation(for: "folder.view.error.title")
    static let folderViewErrorCTA = translation(for: "folder.view.error.cta")
    static let folderViewEmpty = translation(for: "folder.view.empty")
}

private func translation(for key: String) -> String {
    Bundle.module.localizedString(forKey: key, value: nil, table: "Localizable")
}
