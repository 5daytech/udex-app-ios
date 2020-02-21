import SwiftUI

struct ConvertView: View {
  @ObservedObject var viewModel: ConvertViewModel
  
  @State var inputed: String = ""
  
  var body: some View {
    ZStack {
      VStack(alignment: .leading, spacing: 10) {
        HStack {
          Image(self.viewModel.coinCode)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20)
          Text(self.viewModel.title)
            .fontWeight(.bold)
            +
          Text(" ")
            +
            Text(self.viewModel.coinCode)
            .foregroundColor(Color("main"))
            .fontWeight(.bold)
        }
        Text("AVAILABLE BALANCE")
          .font(Font.system(size: 12))
          .foregroundColor(Color("T2"))
        Text("\(self.viewModel.availableBalance.toDisplayFormat()) ETH")
          .foregroundColor(Color("T1"))
          .font(Font.system(size: 18, weight: .bold))
        Text("$\(self.viewModel.availableBalanceInFiat.toDisplayFormat(2))")
          .font(Font.system(size: 12))
          .foregroundColor(Color("T2"))
        Text("You send $\(self.viewModel.sendAmountInFiat.toDisplayFormat(2))")
          .font(Font.system(size: 10))
          .foregroundColor(Color("T3"))
        HStack {
          Text("ETH")
            .fontWeight(.bold)
            .foregroundColor(Color("T2"))
          PipeInputView(isPipeShowing: true, text: self.viewModel.amount)
        }
        
        Rectangle()
          .foregroundColor(Color.gray)
          .frame(height: 1)
        
        HStack {
          Text("Estimated fee")
            .font(Font.system(size: 12))
            .foregroundColor(Color("T2"))
          Spacer()
          Text("~\(self.viewModel.estimatedFee.toDisplayFormat()) ETH")
            .foregroundColor(Color("T1"))
            .font(Font.system(size: 12))
        }
        
        Button(action: {
          self.viewModel.convert()
        }) {
          Spacer()
          Text(self.viewModel.title.uppercased())
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(Color("background"))
            .padding([.top, .bottom], 16)
          Spacer()
        }
        .background(Color("main"))
        .cornerRadius(5)
        .opacity(self.viewModel.wrapDisabled ? 0.5 : 1)
        .disabled(self.viewModel.wrapDisabled)
      }
    }
  }
}

extension ConvertView: NumberPadInputable {
  func inputNumber(_ number: String) {
    viewModel.setAmount(number)
  }
  
  func confirmConvert() {
    viewModel.confirm()
  }
}
