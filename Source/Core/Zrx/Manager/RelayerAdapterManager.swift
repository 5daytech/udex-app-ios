import Foundation
import zrxkit

class RelayerAdapterManager: IRelayerAdapterManager {
  let mainRelayer: IRelayerAdapter
  
  init(zrxkit: ZrxKit, coinManager: ICoinManager) {
    mainRelayer = BaseRelayerAdapter(zrxkit: zrxkit, coinManager: coinManager, relayerId: 0)
  }
}
