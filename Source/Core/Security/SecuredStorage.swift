import Foundation
import KeychainAccess

class SecuredStorage: ISecuredStorage {
  
  private let AUTH_DATA_KEY = "auth_data_key"
  private let PIN_KEY = "pin_key"
  private let FACE_ID_KEY = "face_id_key"
  private let APPLICATION_SERVICE = "fridaytech.udex.dev"
  
  private let keychain: Keychain
  
  var authData: AuthData? {
    guard let data = try? keychain.get(AUTH_DATA_KEY) else {
      return nil
    }
    return AuthData(serialized: data)
  }
  
  var savedPin: String? {
    try? keychain.get(PIN_KEY)
  }
  
  init() {
    keychain = Keychain(service: APPLICATION_SERVICE)
  }
  
  func saveAuthData(authData: AuthData) {
    try! keychain.set("\(authData)", key: AUTH_DATA_KEY)
  }
  
  func removeAuthData() {
    try! keychain.remove(AUTH_DATA_KEY)
  }
  
  func noAuthData() -> Bool {
    return try! keychain.get(AUTH_DATA_KEY) == nil
  }
  
  func savePin(pin: String) {
    try! keychain.set(pin, key: PIN_KEY)
  }
  
  func pinIsEmpty() -> Bool {
    return try! keychain.get(PIN_KEY) == nil
  }
  
  func removePin() {
    try! keychain.remove(PIN_KEY)
  }
  
  func turnOnFaceID() {
    try! keychain.set("1", key: FACE_ID_KEY)
  }
  
  func turnOffFaceID() {
    try! keychain.remove(FACE_ID_KEY)
  }
  
  func isFaceIDOn() -> Bool {
    try! keychain.get(FACE_ID_KEY) == "1"
  }
}
