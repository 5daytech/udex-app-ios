import Foundation
import zrxkit
import EthereumKit
import RxSwift
import BigInt

class AllowanceChecker: IAllowanceChecker {
  let zrxkit: ZrxKit
  let ethereumKit: EthereumKit.Kit
  
  init(zrxkit: ZrxKit, ethereumKit: EthereumKit.Kit) {
    self.zrxkit = zrxkit
    self.ethereumKit = ethereumKit
  }
  
  func checkAndUnlockAssetPairForPost(assetPair: Pair<AssetItem, AssetItem>, side: EOrderSide) -> Observable<Bool> {
    checkAndUnlockTokenAddress(address: side == .SELL ? assetPair.first.address : assetPair.second.address)
  }
  
  func checkAndUnlockPairForFill(pair: Pair<String, String>, side: EOrderSide) -> Observable<Bool> {
    checkAndUnlockTokenAddress(address: side == .SELL ? pair.second : pair.first)
  }
  
  private func checkAndUnlockTokenAddress(address: String) -> Observable<Bool> {
    let coinWrapper = zrxkit.getErc20ProxyInstance(tokenAddress: address)
    
    return coinWrapper.proxyAllowance(ethereumKit.receiveAddress).flatMap { (allowance) -> Observable<Bool> in
      if allowance > BigUInt.zero {
        return Observable.just(true)
      } else {
        return coinWrapper.setUnlimitedProxyAllowance().flatMap { (data) -> Observable<Bool> in
          return Observable.just(true)
        }
      }
    }
  }
}
