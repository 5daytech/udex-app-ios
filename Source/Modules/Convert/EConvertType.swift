import Foundation

enum EConvertType {
  case WRAP
  case UNWRAP
  case NONE
  
  var title: String {
    switch self {
    case .WRAP:
      return "Wrap"
    case .UNWRAP:
      return "Unwrap"
    default:
      return "NONE"
    }
  }
}
