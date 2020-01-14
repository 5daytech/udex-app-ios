import Foundation
import SwiftUI

class ExchangeConfirmViewModel: ObservableObject {
  let info: ExchangeConfirmInfo
  
  var sellAmount: String {
    "\(info.sendAmount)"
  }
  
  var buyAmount: String {
    "\(info.receiveAmount)"
  }
  
  var priceAmount: String {
    numberFormatter.string(from: price as NSDecimalNumber) ?? ""
  }
  
  @Published var feeAmount: String = "0.0"
  
  private var price: Decimal {
    info.receiveAmount / info.sendAmount
  }
  
  let numberFormatter: NumberFormatter
  
  init(info: ExchangeConfirmInfo) {
    self.info = info
    numberFormatter = NumberFormatter()
    numberFormatter.maximumFractionDigits = 4
  }
  
  func onConfirm() {
    info.onConfirm()
  }
}
