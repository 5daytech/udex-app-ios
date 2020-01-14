import Foundation

struct ExchangeConfirmInfo {
  let sendCoin: String
  let receiveCoin: String
  let sendAmount: Decimal
  let receiveAmount: Decimal
  let showLifeTimeInfo: Bool
  let onConfirm: () -> Void
}
