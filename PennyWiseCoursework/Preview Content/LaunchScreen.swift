import SwiftUI

struct LaunchScreen: View {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    private let gradientColors = LinearGradient(
        gradient: Gradient(colors: [Color.purple, Color.blue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        ZStack {
            gradientColors
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Image("Image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding(.top, 80)
                
                Text("Welcome to PennyWise")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                
                Text("Track your expenses effortlessly")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 20) {
                    PointView(symbol: "dollarsign.circle.fill", title: "Transactions", subTitle: "Track income and expenses")
                    PointView(symbol: "magnifyingglass.circle.fill", title: "Search & Filter", subTitle: "Find transactions easily")
                    PointView(symbol: "chart.pie.fill", title: "Visual Charts", subTitle: "View your spending trends")
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
                .padding(.horizontal, 25)
                
                Spacer()
                
                Button(action: {
                    isFirstTime = false
                }) {
                    Text("Get Started")
                        .fontWeight(.bold)
                        .frame(width: 250, height: 50)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(25)
                }
                .padding(.bottom, 50)
            }
        }
    }
    
    @ViewBuilder
    func PointView(symbol: String, title: String, subTitle: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: symbol)
                .font(.system(size: 40))
                .foregroundStyle(LinearGradient(
                    gradient: Gradient(colors: [Color.yellow, Color.orange]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 60, height: 60)
                .background(Color.white.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text(subTitle)
                    .font(.subheadline)
                    .foregroundColor(Color.white.opacity(0.7))
            }
        }
    }
}

#Preview {
    LaunchScreen()
}
