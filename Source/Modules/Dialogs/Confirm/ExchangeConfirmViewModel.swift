import Foundation
import SwiftUI

class ExchangeConfirmViewModel: ObservableObject {
  let info: ExchangeConfirmInfo
  private let processingDurationProvider = App.instance.processingDurationProvider
  
  var sellAmount: String {
    "\(info.sendAmount)"
  }
  
  var buyAmount: String {
    "\(info.receiveAmount)"
  }
  
  var priceAmount: String {
    price.toDisplayFormat()
  }
  
  var feeAmount: String? {
    info.fee?.toDisplayFormat()
  }
  
  var processingTime: String {
    "\(processingDurationProvider.getEstimatedDuration(type: .EXCHANGE))"
  }
  
  private var price: Decimal {
    info.receiveAmount / info.sendAmount
  }
  
  init(info: ExchangeConfirmInfo) {
    self.info = info
  }
  
  func onConfirm() {
    info.onConfirm()
  }
}
