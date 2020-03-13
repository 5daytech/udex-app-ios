import Foundation

protocol IPinManager {
  var isPinSet: Bool { get }
  
  func store(pin: String)
  func validate(pin: String) -> Bool
  func clear()
}
