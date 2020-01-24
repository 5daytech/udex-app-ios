import Foundation

class CleanupManager: ICleanupManager {
  private let authManager: IAuthManager
  private let zrxKitManager: IZrxKitManager
  
//  private let keyStoreManager: IKeyStoreManager
//  private let appPreferences: IAppPreferences
  
  init(authManager: IAuthManager, zrxKitManager: IZrxKitManager) {
    self.authManager = authManager
    self.zrxKitManager = zrxKitManager
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
    //TODO: Remove key from keystore
  }
}
