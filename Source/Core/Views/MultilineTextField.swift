import SwiftUI
import UIKit

struct MultilineTextField: UIViewRepresentable {
  typealias UIViewType = UITextView
  class Coordinator: NSObject, UITextViewDelegate {
    @Binding var text: String
    
    init(text: Binding<String>) {
      _text = text
    }
    
    func textViewDidChange(_ textView: UITextView) {
      text = textView.text
    }
  }
  
  @Binding var text: String
  
  func makeUIView(context: UIViewRepresentableContext<MultilineTextField>) -> MultilineTextField.UIViewType {
    let view = UITextView()
    view.isScrollEnabled = false
    view.isEditable = true
    view.isUserInteractionEnabled = true
    view.font = UIFont.systemFont(ofSize: 18)
    view.tintColor = UIColor(named: "main")
    view.delegate = context.coordinator
    return view
  }
  
  func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultilineTextField>) {
    uiView.text = text
    uiView.becomeFirstResponder()
  }
  
  func makeCoordinator() -> MultilineTextField.Coordinator {
    return Coordinator(text: $text)
  }
}
