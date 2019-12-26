import Foundation

struct BalanceViewItem: Identifiable {
  var id = UUID().uuidString
  let title: String
  let balance: String
  let code: String
  var expanded: Bool
}

