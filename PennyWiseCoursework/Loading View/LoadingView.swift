import SwiftUI
 
struct LoadView: View {
    @State var progress: CGFloat = 0
    @State var doneLoading: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            if doneLoading {
                LaunchScreen()
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
            } else {
                LoadingView(content: Image("coin")
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, 50),
                            progress: $progress)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                self.progress = 0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                withAnimation {
                                    self.doneLoading = true
                                }
                            }
                        }
                    }
            }
        }
    }
}

 
struct LoadView_Previews: PreviewProvider {
    static var previews: some View {
        LoadView()
    }
}
 
 

 

