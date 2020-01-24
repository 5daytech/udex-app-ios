import Foundation
import RxSwift

class SecurityCenterViewModel: ObservableObject {
  private let cleanupManager: ICleanupManager
  
  init(cleanupManager: ICleanupManager) {
    self.cleanupManager = cleanupManager
  }
  
  let logoutSubject = PublishSubject<Void>()
  
  func logout() {
    cleanupManager.logout()
    logoutSubject.onNext(())
  }
}
