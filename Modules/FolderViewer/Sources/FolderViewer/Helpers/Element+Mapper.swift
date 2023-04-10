import Foundation
import World

extension Item {
    final class Mapper {
        private(set) lazy var dateFormatter = {
            let formatter = DateFormatter()
            // TODO: Set locale from World
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter
        }()

        private(set) lazy var sizeFormatter = {
            let formatter = ByteCountFormatter()
            // TODO: Set locale from World
            return formatter
        }()
    }

    struct ViewState: Equatable, Identifiable {
        enum Kind {
            case file
            case directory
        }

        var id: Item.ID { raw.id }

        let raw: Item
        let title: String
        let size: String?
        let modificationDate: String?
        let kind: Kind
    }

    func toViewState(using mapper: Item.Mapper) -> Item.ViewState {
        .init(
            raw: self,
            title: name,
            size: size.map { mapper.sizeFormatter.string(fromByteCount: Int64($0)) },
            modificationDate: mapper.dateFormatter.string(from: modificationDate),
            kind: isFolder ? .directory : .file
        )
    }
}
