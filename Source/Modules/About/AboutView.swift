import SwiftUI

struct AboutView: View {
  
  func getAppIcon() -> UIImage {
    return Bundle.main.icon!
  }
  
  var body: some View {
    List {
      VStack(alignment: .leading) {
        HStack {
          Image(uiImage: getAppIcon())
          VStack(alignment: .leading) {
            Text("UDEX")
            Text("Decentralized App")
          }
          Spacer()
        }
        Text("Terms & Privacy:")
        Text("UDEX runs on a peer-to-peer network. It does not depend on web servers or specialist personnel in order to function.\n\nProviding there is an internet connection, UDEX will work anywhere in the world. No entity can block the app from functioning or block someone from using it.\n\nYour funds are securely stored on your phone or tablet. Nobody including UDEX has access to them or can see them.\n\nIt’s your responsibility to back up your private key and keep it safe. Never show it to anyone. If it’s lost, forgotten, or stolen, your funds are at risk.\n\nDo not jailbreak your phone, do not install apps from unknown or untrusted sources, do not give your device to untrusted people, and keep the operating system on your phone up to date. Failure to follow this guidance will put your assets at risk.\n\nThe code powering UDEX is open to public scrutiny and has been since development began. The app is significantly more secure than proprietary smartphone exchanges, but we cannot guarantee an absence of bugs and security issues. The developers accept no liability for lost assets.")
        Spacer()
      }
    }
    .navigationBarTitle("About UDEX")
  }
}
