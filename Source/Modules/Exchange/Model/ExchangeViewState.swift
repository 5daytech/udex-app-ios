import Foundation

struct ExchangeViewState {
  var sendAmount: Decimal
  var sendAmountFiat: Decimal
  var errorMessageSend: String?
  var sendCoin: ExchangeCoinViewItem?
  var receiveAmount: Decimal
  var receiveCoin: ExchangeCoinViewItem?
  var receiveAdditional: Decimal?
  var sendAvailableAmount: Decimal?
  var receiveAvailableAmount: Decimal?
  
  init(
    sendCoin: ExchangeCoinViewItem? = nil,
    receiveCoin: ExchangeCoinViewItem? = nil
  ) {
    self.sendAmount = 0
    self.sendAmountFiat = 0
    self.errorMessageSend = nil
    self.sendCoin = sendCoin
    self.receiveAmount = 0
    self.receiveCoin = receiveCoin
    self.receiveAdditional = nil
  }
  
  var receiveTotal: String? {
    if receiveAdditional != nil {
      return "\(receiveAdditional!.toDisplayFormat()) \(receiveCoin?.coin.code ?? "")"
    } else {
      return nil
    }
  }
}
