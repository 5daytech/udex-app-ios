import Foundation

class SecuredStorage: ISecuredStorage {
  
  private let AUTH_DATA_KEY = "auth_data_key"
  
  var authData: AuthData? {
    guard let data = UserDefaults.standard.string(forKey: AUTH_DATA_KEY) else {
      return nil
    }
    return AuthData(serialized: data)
  }
  
  var savedPin: String?
  
  func saveAuthData(authData: AuthData) {
    UserDefaults.standard.set("\(authData)", forKey: AUTH_DATA_KEY)
  }
  
  func removeAuthData() {
    UserDefaults.standard.set(nil, forKey: AUTH_DATA_KEY)
  }
  
  func noAuthData() -> Bool {
    return UserDefaults.standard.string(forKey: AUTH_DATA_KEY) == nil
  }
  
  func savePin(pin: String) {
    
  }
  
  func pinIsEmpty() -> Bool {
    return true
  }
  
  func removePin() {
    
  }
}
