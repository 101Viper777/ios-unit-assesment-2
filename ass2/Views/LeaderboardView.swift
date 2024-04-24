import SwiftUI
struct LeaderboardView: View {
    @ObservedObject var leaderboardViewModel: LeaderboardViewModel
    @Binding var playerScore: Int
    @Environment(\.presentationMode) var presentationMode
    @Binding var showGameView: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.green, Color.indigo]), startPoint: .leading, endPoint: .trailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    List(leaderboardViewModel.leaderboardData) { entry in
                        HStack {
                            Text(entry.name)
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(entry.score)")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding(.vertical)
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your Final Score")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        Text("\(playerScore)")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    .padding()
                    
                   
                    Button(action: {
                                         leaderboardViewModel.resetLeaderboard()
                                     }) {
                                         Text("Reset Leaderboard")
                                             .font(.headline)
                                             .foregroundColor(.white)
                                             .padding()
                                             .frame(maxWidth: .infinity)
                                             .background(
                                                 RoundedRectangle(cornerRadius: 20)
                                                     .fill(Color.red)
                                             )
                                     }
                                     .padding(.horizontal)
                                     .padding(.bottom)
                }
                .navigationBarTitle("Leaderboard", displayMode: .inline)
                .onAppear {
                    leaderboardViewModel.getLeaderboardData()
                }
            }
        }
    }
}
struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        let leaderboardViewModel = LeaderboardViewModel()
        leaderboardViewModel.leaderboardData = [
            LeaderboardEntry(id: UUID(), name: "Player 1", score: 100),
            LeaderboardEntry(id: UUID(), name: "Player 2", score: 90),
            LeaderboardEntry(id: UUID(), name: "Player 3", score: 80),
            LeaderboardEntry(id: UUID(), name: "Player 4", score: 70),
            LeaderboardEntry(id: UUID(), name: "Player 5", score: 60)
        ]
        
        return LeaderboardView(leaderboardViewModel: leaderboardViewModel, playerScore: .constant(85), showGameView: .constant(false))
    }
}
