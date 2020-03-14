import Foundation
import RxSwift

class LockManager: ILockManager {
  private let lockTimeout = 10.0
  
  private let pinManager: IPinManager
  
  var lockStateUpdatedSignal = PublishSubject<Void>()
  var isLocked: Bool {
    didSet {
      lockStateUpdatedSignal.onNext(())
    }
  }
  
  init(pinManager: IPinManager) {
    isLocked = false
    self.pinManager = pinManager
  }
  
  func onUnlock() {
    isLocked = false
  }
  
  func didEnterBackground() {
    if (isLocked) { return }
    App.instance.lastExitDate = Date().timeIntervalSince1970
  }
  
  func willEnterForeground() {
    if (isLocked || !pinManager.isPinSet) { return }
    
    let secondsAgo = Date().timeIntervalSince1970 - App.instance.lastExitDate
    if secondsAgo > lockTimeout {
      isLocked = true
    }
  }
}
