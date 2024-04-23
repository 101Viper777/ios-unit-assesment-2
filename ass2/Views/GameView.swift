import SwiftUI
struct GameView: View {
    @StateObject private var gameViewModel: GameViewModel
    @Binding var showLeaderboard: Bool
    @Binding var showGameView: Bool
    @Binding var playerName: String
    @State private var showCountdown = true
    @State private var consecutivePopCount = 0
    
    init(showLeaderboard: Binding<Bool>, showGameView: Binding<Bool>, playerName: Binding<String>) {
        self._showLeaderboard = showLeaderboard
        self._showGameView = showGameView
        self._playerName = playerName
        self._gameViewModel = StateObject(wrappedValue: GameViewModel(playerName: playerName.wrappedValue, showGameView: showGameView))
    }
    var body: some View {
        var scoreColor: Color {
               let progress = min(1.0, Double(gameViewModel.score) / Double(gameViewModel.highestScore))
               return interpolate(from: Color.white, to: Color(red: 1.0, green: 0.84, blue: 0.0), amount: progress)
           }
        ZStack {
            if gameViewModel.consecutivePopCount > 1 {
                       Text("Combo x\(gameViewModel.consecutivePopCount)")
                           .font(.title)
                           .fontWeight(.bold)
                           .foregroundColor(.white)
                           .padding()
                           .background(Color.black.opacity(0.6))
                           .cornerRadius(10)
                           .animation(.easeInOut)
                           .transition(.opacity)
                           .zIndex(1)
                   }
               
            LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.purple]), startPoint: .top, endPoint: .bottom)
                     .edgesIgnoringSafeArea(.all)
                 
            VStack {
                HStack {
                    Text("Score: \(gameViewModel.score)")
                        .font(.headline)
                                           .fontWeight(.bold)
                                           .foregroundColor(scoreColor)
                                           .animation(.easeInOut(duration: 0.5))
                    
                    Spacer()
                    
                    Text("Time: \(gameViewModel.gameTimeRemaining)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                                       Text("High Score: \(gameViewModel.highestScore)")
                        .font(.headline)
                                              .fontWeight(.bold)
                                              .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0))
                }
                .padding()
          
                Spacer()
                
                ZStack {
                    ForEach(gameViewModel.bubbles) { bubble in
                        BubbleView(bubble: bubble)
                            .onTapGesture {
                                gameViewModel.popBubble(bubble: bubble)
                            }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Spacer()
            }
            .padding()
            .onAppear {
                gameViewModel.startGame()
            }
       
            if showCountdown {
                CountdownView(showCountdown: $showCountdown)
                    .transition(.opacity)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $gameViewModel.showLeaderboard) {
            LeaderboardView(leaderboardViewModel: LeaderboardViewModel(), playerScore: $gameViewModel.playerScore, showGameView: $showGameView)
        }
    }
    func interpolate(from: Color, to: Color, amount: Double) -> Color {
           let amount = amount.clamp(min: 0, max: 1)
           let fromComponents = from.components
           let toComponents = to.components
           let red = fromComponents.red + (toComponents.red - fromComponents.red) * amount
           let green = fromComponents.green + (toComponents.green - fromComponents.green) * amount
           let blue = fromComponents.blue + (toComponents.blue - fromComponents.blue) * amount
           return Color(red: red, green: green, blue: blue)
       }
   }

   extension Color {
       var components: (red: Double, green: Double, blue: Double, opacity: Double) {
           var red: CGFloat = 0
           var green: CGFloat = 0
           var blue: CGFloat = 0
           var opacity: CGFloat = 0
           guard UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &opacity) else {
               return (0, 0, 0, 0)
           }
           return (Double(red), Double(green), Double(blue), Double(opacity))
       }
   }

   extension Double {
       func clamp(min: Double, max: Double) -> Double {
           return self < min ? min : (self > max ? max : self)
       }
   
}
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(showLeaderboard: .constant(false), showGameView: .constant(true), playerName: .constant("Test Player"))
    }
}
