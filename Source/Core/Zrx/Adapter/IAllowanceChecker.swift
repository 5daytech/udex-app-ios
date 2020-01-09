import Foundation
import zrxkit
import RxSwift

protocol IAllowanceChecker {
  func checkAndUnlockAssetPairForPost(assetPair: Pair<AssetItem, AssetItem>, side: EOrderSide) -> Observable<Bool>
  func checkAndUnlockPairForFill(pair: Pair<String, String>, side: EOrderSide) -> Observable<Bool>
}
