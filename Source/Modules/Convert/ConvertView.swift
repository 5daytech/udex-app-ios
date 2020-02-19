import SwiftUI

struct ConvertView: View {
  
  @ObservedObject var viewModel = ConvertViewModel()
  
  @State var inputed: String = ""
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack {
        Image("ETH")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 20, height: 20)
        Text("Wrap ")
          .fontWeight(.bold)
          +
        Text("ETH")
          .foregroundColor(Color("main"))
          .fontWeight(.bold)
      }
      Text("AVAILABLE BALANCE")
        .font(Font.system(size: 12))
        .foregroundColor(Color("T2"))
      Text("0.6969 ETH")
        .foregroundColor(Color("T1"))
        .font(Font.system(size: 18, weight: .bold))
      Text("$ 193.00")
        .font(Font.system(size: 12))
        .foregroundColor(Color("T2"))
      Text("You send $0.0")
        .font(Font.system(size: 10))
        .foregroundColor(Color("T3"))
      HStack {
        Text("ETH")
          .fontWeight(.bold)
          .foregroundColor(Color("T2"))
        PipeInputView(isPipeShowing: true, text: viewModel.amount)
      }
      
      Rectangle()
        .foregroundColor(Color.gray)
        .frame(height: 1)
      
      HStack {
        Text("Estimated fee")
          .font(Font.system(size: 12))
          .foregroundColor(Color("T2"))
        Spacer()
        Text("~ 0.0008 ETH")
          .foregroundColor(Color("T1"))
          .font(Font.system(size: 12))
      }
      
      Button(action: {
        
      }) {
        Spacer()
        Text("WRAP")
          .font(.system(size: 18, weight: .bold))
          .foregroundColor(Color("background"))
          .padding([.top, .bottom], 16)
        Spacer()
      }
      .background(Color("main"))
      .cornerRadius(5)
      .opacity(viewModel.wrapDisabled ? 0.5 : 1)
      .disabled(viewModel.wrapDisabled)
    }
    .padding(16)
  }
}

extension ConvertView: NumberPadInputable {
  func inputNumber(_ number: String) {
    viewModel.setAmount(number)
  }
}

struct ConvertView_Previews: PreviewProvider {
  static var previews: some View {
    ConvertView()
  }
}
