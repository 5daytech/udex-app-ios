import Foundation
import RxSwift

protocol ILockManager {
  var lockStateUpdatedSignal: PublishSubject<Void> { get }
  var isLocked: Bool { get }
  func onUnlock()
  
  func didEnterBackground()
  func willEnterForeground()
}
