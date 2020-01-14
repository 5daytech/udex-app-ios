import SwiftUI

struct ProgressBar: View {
  @Binding var value: CGFloat
  
  private func getProgressBarWidth(geometry: GeometryProxy) -> CGFloat {
    let frame = geometry.frame(in: .global)
    return frame.size.width * value / 60
  }
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        Rectangle()
          .opacity(0.1)
        Rectangle()
        .frame(
          minWidth: 0,
          idealWidth: self.getProgressBarWidth(geometry: geometry),
          maxWidth: self.getProgressBarWidth(geometry: geometry)
        )
        .foregroundColor(Color("main"))
        .animation(.default)
      }
      .frame(height: 10)
    }
  }
}

struct ProgressBar_Previews: PreviewProvider {
  @State static var value: CGFloat = 50
  
  static var previews: some View {
    ProgressBar(value: $value)
  }
}
