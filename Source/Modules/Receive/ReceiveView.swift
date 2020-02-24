import SwiftUI
import CoreImage.CIFilterBuiltins

struct ReceiveView: View {
  
  @State private var showingAlert = false
  @State private var showShareSheet = false
  var viewModel: ReceiveViewModel
  
  let context = CIContext()
  let filter = CIFilter.qrCodeGenerator()
  
  func generateQRCode(from string: String) -> UIImage {
    let data = Data(string.utf8)
    filter.setValue(data, forKey: "inputMessage")
    
    if let outputImage = filter.outputImage {
      let scaleFactor = 150 / outputImage.extent.width
      let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
      
      if let cgimg = context.createCGImage(scaledImage, from: scaledImage.extent) {
        
        return UIImage(cgImage: cgimg)
      }
    }
    
    return UIImage(systemName: "xmark.circle") ?? UIImage()
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack {
        Image(viewModel.coin.code)
          .resizable()
          .frame(width: 25, height: 25)
        Text("Receive") +
        Text(" ") +
        Text(viewModel.coin.title)
          .font(.system(size: 17, weight: .bold))
          .foregroundColor(Color("main"))
        Spacer()
      }
      
      HStack {
        Spacer()
        Image(uiImage: generateQRCode(from: viewModel.address))
          .resizable()
          .frame(width: 100, height: 100)
        Spacer()
      }
      
      Text("Your address")
        .font(Font.system(size: 12))
        .foregroundColor(Color("T2"))
      HStack(alignment: .center) {
        Spacer()
        Text(viewModel.address)
          .font(.system(size: 11, weight: .bold))
          .padding([.top, .bottom], 5)
        Spacer()
      }
      .onTapGesture {
        self.showingAlert = true
        UIPasteboard.general.string = self.viewModel.address
      }
      .alert(isPresented: $showingAlert) {
        Alert(title: Text("Copied!"), dismissButton: .default(Text("Done")))
      }
      .border(Color.gray, width: 1)
      
      Button(action: {
        self.showShareSheet = true
      }) {
        Spacer()
        Text("SHARE")
          .font(.system(size: 18, weight: .bold))
          .foregroundColor(Color("background"))
          .padding([.top, .bottom], 16)
        Spacer()
      }
      .background(Color("main"))
      .cornerRadius(5)
    }
    .padding(16)
    .sheet(isPresented: $showShareSheet) {
      ShareSheet(activityItems: [self.viewModel.address])
    }
  }
}

extension ReceiveView: NumberPadInputable {
  func inputNumber(_ number: String) {
    
  }
}
