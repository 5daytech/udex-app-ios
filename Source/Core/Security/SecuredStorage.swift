import Foundation
import KeychainAccess

class SecuredStorage: ISecuredStorage {
  
  private let AUTH_DATA_KEY = "auth_data_key"
  private let APPLICATION_SERVICE = "fridaytech.udex.dev"
  
  var authData: AuthData? {
    let keychain = Keychain(service: APPLICATION_SERVICE)
    guard let data = try? keychain.get(AUTH_DATA_KEY) else {
      return nil
    }
    
    return AuthData(serialized: data)
  }
  
  var savedPin: String?
  
  func saveAuthData(authData: AuthData) {
    let keychain = Keychain(service: APPLICATION_SERVICE)
    try! keychain.set("\(authData)", key: AUTH_DATA_KEY)
  }
  
  func removeAuthData() {
    let keychain = Keychain(service: APPLICATION_SERVICE)
    try! keychain.remove(AUTH_DATA_KEY)
  }
  
  func noAuthData() -> Bool {
    let keychain = Keychain(service: APPLICATION_SERVICE)
    return try! keychain.get(AUTH_DATA_KEY) == nil
  }
  
  func savePin(pin: String) {
    
  }
  
  func pinIsEmpty() -> Bool {
    return true
  }
  
  func removePin() {
    
  }
}
