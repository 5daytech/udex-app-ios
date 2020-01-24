import SwiftUI

struct ShowKeyView: View {
  var body: some View {
    VStack {
      Text("The key that will be shown next is the only way to restore your funds if your phone is ever lost, stolen, broken etc. \n\nMake sure that no one is watching your screen.")
        .padding(16)
        
      Spacer()
      
      NavigationLink(destination: BackupView()) {
        HStack {
          Spacer()
          Text("SHOW KEY")
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(Color("background"))
            .padding([.top, .bottom], 16)
          Spacer()
        }
        .background(Color("main"))
      }
    }
  .navigationBarTitle("Show key")
  }
}

struct ShowKeyView_Previews: PreviewProvider {
  static var previews: some View {
    ShowKeyView()
  }
}
