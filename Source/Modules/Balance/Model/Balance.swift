import Foundation

struct Balance: Identifiable {
  var id = UUID().uuidString
  let balance: String
  var expanded: Bool
}

