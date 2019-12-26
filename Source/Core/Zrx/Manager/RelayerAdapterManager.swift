import Foundation
import zrxkit

class RelayerAdapterManager: IRelayerAdapterManager {
  let mainRelayer: IRelayerAdapter
  
  init(zrxkit: ZrxKit, coinManager: ICoinManager) {
    mainRelayer = BaseRelayerAdapter(
      zrxkit: zrxkit,
      coinManager: coinManager,
      refreshInterval: 10_000_000,
      relayerId: 0
    )
  }
}
