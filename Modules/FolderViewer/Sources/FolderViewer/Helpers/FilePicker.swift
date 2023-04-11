import UIKit
import World
import Architecture

final class FilePicker: NSObject, UIDocumentPickerDelegate {
    private var selectedFile: (File) -> Void
    private let documentPicker: UIDocumentPickerViewController

    override init() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.png, .jpeg, .audio, .pdf, .text, .plainText])
        documentPicker.allowsMultipleSelection = false
        documentPicker.shouldShowFileExtensions = true
        self.documentPicker = documentPicker
        self.selectedFile = { _ in }
        super.init()
        documentPicker.delegate = self
    }

    func present(selectedFile: @escaping (File) -> Void, on navigationController: UINavigationController) {
        self.selectedFile = selectedFile
        navigationController.present(documentPicker, animated: true)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        selectedFile(File(name: url.lastPathComponent, url: url))
    }
}
