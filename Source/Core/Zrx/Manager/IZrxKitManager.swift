import Foundation
import zrxkit

protocol IZrxKitManager {
  var zrxkit: ZrxKit { get }
  var zrxExchange: IZrxExchange { get }
}
