import SwiftUI
struct GameView: View {
    @ObservedObject var gameViewModel: GameViewModel
    @Binding var showLeaderboard: Bool
    @Binding var showGameView: Bool
    
    init(playerName: String, playerScore: Binding<Int>, showLeaderboard: Binding<Bool>, showGameView: Binding<Bool>) {
        self.gameViewModel = GameViewModel(playerName: playerName, playerScore: playerScore, showGameView: showGameView)
        self._showLeaderboard = showLeaderboard
        self._showGameView = showGameView
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Score: \(gameViewModel.score)")
                    Spacer()
                    Text("Time: \(gameViewModel.gameTimeRemaining)")
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
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $gameViewModel.showLeaderboard) {
            LeaderboardView(leaderboardViewModel: LeaderboardViewModel(), playerScore: gameViewModel.playerScore, showGameView: $showGameView)
    
                }
    }
}
//
//struct GameView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameView(playerName: "Test Player", playerScore: .constant(0), showGameView: .constant(true))
//    }
//}
