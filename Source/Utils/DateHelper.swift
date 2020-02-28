import Foundation

class DateHelper {
  static let instance = DateHelper()
  
  private let dayFormatter: DateFormatter
  private let timeFormatter: DateFormatter
  private let fullFormatter: DateFormatter
  
  init() {
    dayFormatter = DateFormatter()
    dayFormatter.dateFormat = "MMM dd"
    timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "hh:mm a"
    fullFormatter = DateFormatter()
    fullFormatter.dateFormat = "MMM dd, yyyy, hh:mm a"
  }
  
  func day(_ date: Date) -> String {
    dayFormatter.string(from: date)
  }
  
  func time(_ date: Date) -> String {
    timeFormatter.string(from: date)
  }
  
  func full(_ date: Date) -> String {
    fullFormatter.string(from: date)
  }
}
