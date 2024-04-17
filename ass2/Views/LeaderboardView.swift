import SwiftUI

struct LeaderboardView: View {
    @ObservedObject var leaderboardViewModel: LeaderboardViewModel
    let playerScore: Int
    @Environment(\.presentationMode) var presentationMode
    @Binding var showGameView: Bool

    var body: some View {
        VStack {
            Text("Leaderboard")
                .font(.largeTitle)
                .padding()
            
            List(leaderboardViewModel.leaderboardData) { entry in
                HStack {
                    Text(entry.name)
                    Spacer()
                    Text("\(entry.score)")
                }
            }
            
            Text("Your Score: \(playerScore)")
                .font(.headline)
                .padding()
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()

                              showGameView = false
            }) {
                Text("Main Menu")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            leaderboardViewModel.getLeaderboardData()
        }
    }
}
struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView(leaderboardViewModel: LeaderboardViewModel(), playerScore: 0, showGameView: .constant(false))
    }
}
