import Foundation

protocol ISecuredStorage {
  var authData: AuthData? { get }
  var savedPin: String? { get }
  
  func saveAuthData(authData: AuthData)
  func removeAuthData()
  func noAuthData() -> Bool
  func savePin(pin: String)
  func pinIsEmpty() -> Bool
  func removePin()
  
  func turnOnFaceID()
  func turnOffFaceID()
  func isFaceIDOn() -> Bool
}
