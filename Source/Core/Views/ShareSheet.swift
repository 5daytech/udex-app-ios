import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
  typealias UIViewControllerType = UIActivityViewController
  
  let activityItems: [Any]
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<ShareSheet>) -> UIActivityViewController {
    let controller = UIActivityViewController(
      activityItems: activityItems,
      applicationActivities: nil
    )
    return controller
  }
  
  func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareSheet>) {
    
  }
  
}
