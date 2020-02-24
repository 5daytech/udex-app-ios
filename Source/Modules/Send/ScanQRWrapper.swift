import SwiftUI

struct ScanQRWrapper: UIViewControllerRepresentable {
  
  
  typealias UIViewControllerType = ScanQRController
  
  class Coordinator: IScanQrCodeDelegate {
    
    let parent: ScanQRWrapper
    
    init(_ parent: ScanQRWrapper) {
      self.parent = parent
    }
    
    func didScan(string: String) {
      parent.onScan(string)
    }
  }
  
  let onScan: (String) -> Void
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<ScanQRWrapper>) -> ScanQRController {
    let controller = ScanQRController(delegate: context.coordinator)
    return controller
  }
  
  func updateUIViewController(_ uiViewController: ScanQRController, context: UIViewControllerRepresentableContext<ScanQRWrapper>) {
    
  }
  
  func makeCoordinator() -> ScanQRWrapper.Coordinator {
    return Coordinator(self)
  }
}
