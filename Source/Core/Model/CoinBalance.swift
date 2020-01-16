import Foundation

struct CoinBalance: Hashable { 
  let coin: Coin
  let balance: Decimal
  let fiatBalance: Decimal
  let pricePerToken: Decimal
  let state: BalanceState
  let convertType: EConvertType
}

enum BalanceState {
  case SYNCED, SYNCING, FAILED
}

enum EConvertType {
  case NONE, WRAP, UNWRAP
}
