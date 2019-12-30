import Foundation

class ExchangeViewModel: ObservableObject {
  enum ExchangeInputType {
    case BASE, QUOTE
  }
  
  var item: ExchangeViewItem
  
  @Published var baseInputText: String? = nil
  @Published var quoteInputText: String? = nil
  @Published var isBaseEditing = false
  @Published var isQuoteEditing = false
  
  var inputType: ExchangeInputType? = nil
  
  init() {
    item = ExchangeViewItem(
      base: ExchangeCoinViewItem(
        code: "ZRX",
        balance: 10.0
      ),
      quote: ExchangeCoinViewItem(
        code: "WETH",
        balance: 10.0
      ),
      baseAmount: 0,
      quoteAmount: 0
    )
  }
  
  func setCurrentInputField(inputType: ExchangeInputType) {
    self.inputType = inputType
    switch inputType {
    case .BASE:
      isBaseEditing = true
      isQuoteEditing = false
    case .QUOTE:
      isBaseEditing = false
      isQuoteEditing = true
    }
  }
  
  func inputNumber(input: String) {
    
    guard let inputType = inputType else { return }
    
    var inputText = inputType == .BASE ? baseInputText : quoteInputText
    switch input {
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
      inputText?.append(input)
    }
    
    switch inputType {
    case .BASE:
      baseInputText = inputText
    case .QUOTE:
      quoteInputText = inputText
    }
  }
}
