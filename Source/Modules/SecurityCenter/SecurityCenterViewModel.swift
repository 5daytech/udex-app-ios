import Foundation
import RxSwift

class SecurityCenterViewModel: ObservableObject {
  private let cleanupManager: ICleanupManager
  
  var onAppear: Bool = false
  
  var isTogglePinEnabled: Bool {
    didSet {
      if onAppear {
        onAppear = false
        return
      }
      if isTogglePinEnabled {
        showPinPage = true
      } else {
        showPinPageForDisable = true
      }
    }
  }
  
  var isPinEnabled: Bool {
    didSet {
      isTogglePinEnabled = isPinEnabled
      isEditDisabled = !isPinEnabled
    }
  }
  
  @Published var showPinPageForDisable: Bool = false
  @Published var showPinPage: Bool = false
  @Published var isEditDisabled: Bool
  
  init(cleanupManager: ICleanupManager, pinManager: IPinManager) {
    self.cleanupManager = cleanupManager
    isPinEnabled = pinManager.isPinSet
    isEditDisabled = !isPinEnabled
    isTogglePinEnabled = isPinEnabled
  }
  
  let logoutSubject = PublishSubject<Void>()
  
  func logout() {
    cleanupManager.logout()
    logoutSubject.onNext(())
  }
  
  func disablePasscode() {
    App.instance.pinManager.clear()
    isPinEnabled = false
  }
  
  func enablePasscode() {
    isPinEnabled = true
  }
  
  func syncToggles() {
    onAppear = true
    isTogglePinEnabled = isPinEnabled
  }
}
