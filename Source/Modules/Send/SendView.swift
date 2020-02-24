import SwiftUI

struct SendView: View {
  
  @ObservedObject var viewModel: SendViewModel
  
  @State var isQRScan = false
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack {
        Image(viewModel.coin.code)
          .resizable()
          .frame(width: 25, height: 25)
        Text("Send") +
        Text(" ") +
        Text(viewModel.coin.title)
          .font(.system(size: 17, weight: .bold))
          .foregroundColor(Color("main"))
        Spacer()
      }
      
      Text("You send $\(viewModel.sendAmountInFiat.toDisplayFormat(2))")
        .foregroundColor(Color("T2"))
        .font(Font.system(size: 11))
      
      HStack {
        Text(self.viewModel.coin.code)
          .fontWeight(.bold)
          .foregroundColor(Color("T2"))
        PipeInputView(isPipeShowing: true, text: self.viewModel.amount)
      }
      
      HStack {
        Text(self.viewModel.address ?? "Address")
          .foregroundColor(Color( self.viewModel.address != nil ? "T1" : "T2"))
          .font(.system(size: 12))
          .lineLimit(1)
        Spacer()
        Button(action: {
          self.isQRScan = true
        }) {
          Image("qr-code")
          .resizable()
          .frame(width: 15, height: 15)
        }
        
        Button(action: {
           self.viewModel.setAddress(UIPasteboard.general.string)
        }) {
          VStack {
            Text("Paste")
              .foregroundColor(Color("T1"))
              .padding(5)
          }
          .background(Color("button_background"))
          .cornerRadius(5)
        }
      }
      
      Button(action: {
        self.viewModel.onSend()
      }) {
        Spacer()
        Text("SEND")
          .font(.system(size: 18, weight: .bold))
          .foregroundColor(Color("background"))
          .padding([.top, .bottom], 16)
        Spacer()
      }
      .background(Color("main"))
      .cornerRadius(5)
      .opacity(self.viewModel.sendDisabled ? 0.5 : 1)
      .disabled(self.viewModel.sendDisabled)
      
    }
      .padding(16)
    .sheet(isPresented: $isQRScan) {
      ScanQRWrapper { (string) in
        self.viewModel.setAddress(string)
      }
    }
  }
}

extension SendView: NumberPadInputable {
  func inputNumber(_ number: String) {
    viewModel.inputNumber(number)
  }
}
