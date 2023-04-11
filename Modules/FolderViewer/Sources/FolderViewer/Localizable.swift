/*
This file should be auto-generated using for example SwiftGen.
*/

import Foundation

enum Localizable {
    static let folderViewErrorTitle = translation(for: "folder.view.error.title")
    static let folderViewErrorCTA = translation(for: "folder.view.error.cta")
    static let folderViewEmpty = translation(for: "folder.view.empty")
    static let folderUploadFileCTA = translation(for: "folder.view.upload.cta")

    static let createFolderTitle = translation(for: "create.folder.title")
    static let createFolderNamePlaceholder = translation(for: "create.folder.name.placeholder")
    static let createFolderCTA = translation(for: "create.folder.cta")
    static let createFolderErrorTitle = translation(for: "create.folder.error.title")
    static let createFolderErrorContent = translation(for: "create.folder.error.content")
    static let createFolderErrorCTA = translation(for: "create.folder.error.cta")
}

private func translation(for key: String) -> String {
    Bundle.module.localizedString(forKey: key, value: nil, table: "Localizable")
}
