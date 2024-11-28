import SwiftUI

struct LoadingView<Content: View>: View {
 
    var content: Content
    @Binding var progress: CGFloat
    @State var logoOffset: CGFloat = 0 
     
    var body: some View {
        content
            .modifier(ScaledMaskModifier(mask: Circle(), progress: progress))
            .offset(x: 0, y: logoOffset)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1)) {
                    self.progress = 1.0
                }
                withAnimation(Animation.easeInOut(duration: 0.4).repeatForever(autoreverses: true)) {
                    self.logoOffset = 10
                }
            }
    }
}
