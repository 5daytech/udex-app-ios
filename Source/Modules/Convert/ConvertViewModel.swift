import Foundation

class ConvertViewModel: ObservableObject {
  
  @Published var amount: String? = nil
  @Published var wrapDisabled: Bool = true
  
  func setAmount(_ number: String) {
    var inputText = amount
    switch number {
    case "d":
      if inputText != nil {
        if inputText!.count > 0 {
          inputText!.removeLast()
        }
        if inputText!.count == 0 {
          inputText = nil
        }
      }
    default:
      if inputText == nil {
        inputText = ""
      }
      inputText?.append(number)
    }
    amount = inputText
  }
}
