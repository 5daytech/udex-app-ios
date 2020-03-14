import Foundation

protocol IPinManager {
  var isPinSet: Bool { get }
  
  var isFaceSet: Bool { get }
  
  func store(pin: String)
  func validate(pin: String) -> Bool
  func clear()
  
  func turnOnFaceID()
  func turnOffFaceID()
}
