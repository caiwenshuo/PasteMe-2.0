import AppKit
import Defaults

// swiftlint:disable identifier_name
// swiftlint:disable type_name
class Sorter {
  enum By: String, CaseIterable, Identifiable, CustomStringConvertible, Defaults.Serializable {
    case lastCopiedAt

    var id: Self { self }

    var description: String {
        return NSLocalizedString("LastCopiedAt", tableName: "StorageSettings", comment: "")
    }
  }

  func sort(_ items: [HistoryItem], by: By = .lastCopiedAt) -> [HistoryItem] {
    return items
      .sorted(by: { return bySortingAlgorithm($0, $1, by) })
      .sorted(by: byPinned)
  }

  private func bySortingAlgorithm(_ lhs: HistoryItem, _ rhs: HistoryItem, _ by: By) -> Bool {
      return lhs.lastCopiedAt > rhs.lastCopiedAt
  }

  private func byPinned(_ lhs: HistoryItem, _ rhs: HistoryItem) -> Bool {
    if Defaults[.pinTo] == .bottom {
      return (lhs.pin == nil) && (rhs.pin != nil)
    } else {
      return (lhs.pin != nil) && (rhs.pin == nil)
    }
  }
}
