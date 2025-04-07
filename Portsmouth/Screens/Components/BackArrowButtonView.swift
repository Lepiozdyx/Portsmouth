import SwiftUI

struct BackArrowButtonView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(.backButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                }
                Spacer()
            }
            Spacer()
        }
        .padding([.top, .horizontal])
    }
}

#Preview {
    BackArrowButtonView()
}
