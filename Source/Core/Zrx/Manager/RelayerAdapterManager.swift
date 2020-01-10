import Foundation
import zrxkit
import EthereumKit

class RelayerAdapterManager: IRelayerAdapterManager {
  let mainRelayer: IRelayerAdapter
  
  init(zrxkit: ZrxKit, ethereumKit: EthereumKit.Kit, coinManager: ICoinManager) {
    let allowanceChecker = AllowanceChecker(zrxkit: zrxkit, ethereumKit: ethereumKit)
    
    let exchangeInteractor = ExchangeInteractor(
      coinManager: coinManager,
      allowanceChecker: allowanceChecker,
      exchangeWrapper: zrxkit.getExchangeInstance(),
      ethereumKit: ethereumKit,
      zrxKit: zrxkit)
    
    mainRelayer = BaseRelayerAdapter(
      zrxkit: zrxkit,
      ethereumKit: ethereumKit,
      coinManager: coinManager,
      exchangeInteractor: exchangeInteractor,
      refreshInterval: 10_000_000,
      relayerId: 0
    )
  }
}
