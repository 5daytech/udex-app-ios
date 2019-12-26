import Foundation
import zrxkit

class BaseRelayerAdapter: IRelayerAdapter {
  let exchangePairs: [ExchangePair]
  
  init(zrxkit: ZrxKit, coinManager: ICoinManager, relayerId: Int) {
    exchangePairs = zrxkit.relayerManager.availableRelayers[relayerId].availablePairs
      .filter { pair -> Bool in
        let baseCoin = coinManager.getErcCoinForAddress(address: pair.first.address)
        let quoteCoin = coinManager.getErcCoinForAddress(address: pair.second.address)
        return baseCoin != nil && quoteCoin != nil
      }
      .map { pair -> ExchangePair in
        ExchangePair(
          baseCoinCode: coinManager.getErcCoinForAddress(address: pair.first.address)?.code ?? "",
          quoteCoinCode: coinManager.getErcCoinForAddress(address: pair.second.address)?.code ?? "",
          baseAsset: pair.first,
          quoteAsset: pair.second
        )
      }
  }
}
