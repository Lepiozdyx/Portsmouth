import SwiftUI

struct LoadingScreenView: View {
    
    @State private var progress: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            BackgoundView(img: .bgload)
            
            VStack {
                Text("LOADING..")
                    .font(.system(size: 20, weight: .heavy, design: .monospaced))
                    .foregroundStyle(.yellow)
                    .shadow(color: .black, radius: 3, x: 1, y: 1)
                
                Capsule()
                    .stroke(.bloody, lineWidth: 5)
                    .frame(width: 310, height: 30)
                    .background(alignment: .leading) {
                        Capsule()
                            .foregroundStyle(.yellow)
                            .frame(width: progress * 305, height: 30)
                            .padding(.horizontal, 2)
                    }
            }
            .padding(.bottom, 30)
        }
        .onAppear {
            withAnimation(.linear(duration: 0.8)) {
                progress = 1
            }
        }
    }
}

#Preview {
    LoadingScreenView()
}
