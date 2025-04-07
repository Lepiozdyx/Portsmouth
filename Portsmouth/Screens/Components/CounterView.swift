import SwiftUI

struct CounterView: View {
    
    let amount: Int
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Image(.undrly1)
                .resizable()
                .frame(width: 130, height: 45)
                .overlay {
                    Text("\(amount)")
                        .font(.system(size: 18, weight: .heavy, design: .default))
                        .foregroundColor(.bloody)
                        .offset(x: -20)
                }
            
            Image(.coin)
                .resizable()
                .scaledToFit()
                .frame(width: 50)
        }
    }
}

#Preview {
    CounterView(amount: 100)
}
