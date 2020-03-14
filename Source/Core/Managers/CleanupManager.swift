import Foundation

class CleanupManager: ICleanupManager {
  private let authManager: IAuthManager
  private let zrxKitManager: IZrxKitManager
  private let securedStorage: ISecuredStorage
  
//  private let keyStoreManager: IKeyStoreManager
//  private let appPreferences: IAppPreferences
  
  init(authManager: IAuthManager, zrxKitManager: IZrxKitManager, securedStorage: ISecuredStorage) {
    self.authManager = authManager
    self.zrxKitManager = zrxKitManager
    self.securedStorage = securedStorage
  }
  
  func logout() {
    cleanUserData()
    removeKey()
    zrxKitManager.unlink()
  }
  
  func cleanUserData() {
    try! authManager.logout()
  }
  
  func removeKey() {
    securedStorage.removePin()
    securedStorage.turnOffFaceID()
  }
}
