import Foundation

struct CoinBalance {
  let coin: Coin
  let balance: Decimal
  let fiatBalance: Decimal
  let pricePerToken: Decimal
  let state: BalanceState
  let convertType: EConvertType
}

extension CoinBalance: Equatable {
  public static func ==(lhs: CoinBalance, rhs: CoinBalance) -> Bool {
    return lhs.coin == rhs.coin
  }
}

enum BalanceState {
  case SYNCED, SYNCING, FAILED
}
