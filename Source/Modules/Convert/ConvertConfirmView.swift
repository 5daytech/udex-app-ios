import SwiftUI

struct ConvertConfirmView: View {
  var onConfirm: () -> Void
  
  var body: some View {
    VStack(spacing: 20) {
      HStack {
        Text("Wrap")
        Spacer()
        Image("ETH")
        .renderingMode(.original)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 25, height: 25)
        Image("wrap_right")
        .renderingMode(.original)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 25, height: 25)
        Image("WETH")
        .renderingMode(.original)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 25, height: 25)
      }
      Text("0.10")
      +
      Text("ETH")
      .foregroundColor(Color("main"))
      
      Text("to")
      .foregroundColor(Color("T2"))
      
      Text("0.10")
      +
      Text("WETH")
      .foregroundColor(Color("main"))
      
      HStack {
        Text("Estimated Fee:")
        .foregroundColor(Color("T2"))
        Spacer()
        Text("~0.0008 ETH")
      }
      HStack {
        Text("Processing Time:")
        .foregroundColor(Color("T2"))
        Spacer()
        Text("~20 s")
      }
      Button(action: {
        self.onConfirm()
      }) {
        Spacer()
        Text("CONFIRM")
          .font(.system(size: 18, weight: .bold))
          .foregroundColor(Color("background"))
          .padding([.top, .bottom], 16)
        Spacer()
      }
      .background(Color("main"))
      .cornerRadius(5)
    }
    .background(Color("secondary_background"))
  }
}
