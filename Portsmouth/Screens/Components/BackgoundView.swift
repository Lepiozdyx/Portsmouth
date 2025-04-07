import SwiftUI

struct BackgoundView: View {
    
    let img: ImageResource
    
    var body: some View {
        Image(img)
            .resizable()
            .ignoresSafeArea()
    }
}

#Preview {
    BackgoundView(img: .bgmenu)
}
