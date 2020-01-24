import Foundation
import zrxkit

protocol IZrxKitManager {  
  func zrxKit() -> ZrxKit
  func unlink()
}
