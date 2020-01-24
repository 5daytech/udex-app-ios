import SwiftUI

struct BackupView: View {
  @ObservedObject var viewModel = BackupViewModel()
  
  struct WordView: View {
    var index: Int
    var word: String
    
    var body: some View {
      HStack {
        Text("\(index).")
          .font(.system(size: 18, weight: .bold))
          .foregroundColor(Color("T2"))
        Text(word)
          .font(.system(size: 18, weight: .bold))
          .foregroundColor(Color("T1"))
      }
    }
  }
  
  var body: some View {
    VStack {
      HStack {
        VStack(alignment: .leading, spacing: 25) {
          ForEach(1...6, id: \.self) { index in
            WordView(index: index, word: self.viewModel.words[index - 1])
          }
        }
        .padding()
        Spacer()
        VStack(alignment: .leading, spacing: 25) {
          ForEach(7...12, id: \.self) { index in
            WordView(index: index, word: self.viewModel.words[index - 1])
          }
        }
        .padding()
      }
      Spacer()
      Button(action: {
        self.viewModel.onCopyClick()
      }) {
        Spacer()
        Text("COPY TO CLIPBOARD")
          .font(.system(size: 15, weight: .bold))
          .foregroundColor(Color("background"))
          .padding([.top, .bottom], 16)
        Spacer()
      }
      .background(Color("main"))
    }
  .navigationBarTitle("Backup")
  }
}

struct BackupView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      BackupView()
      BackupView()
        .environment(\.colorScheme, .dark)
    }
  }
}
