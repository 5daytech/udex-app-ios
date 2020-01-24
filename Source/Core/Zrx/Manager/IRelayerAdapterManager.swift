import Foundation
import RxSwift

protocol IRelayerAdapterManager {
  var mainRelayer: IRelayerAdapter? { get set }
  var mainRelayerUpdatedSignal: Observable<Void> { get }
  
  func clearRelayers()
}
