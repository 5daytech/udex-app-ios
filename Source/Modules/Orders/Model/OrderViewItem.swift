import SwiftUI

struct OrderViewItem: Identifiable {
  var id = UUID().uuidString
  
  let makerAmount: String
  let takerAmount: String
  let isBuy: Bool
}
