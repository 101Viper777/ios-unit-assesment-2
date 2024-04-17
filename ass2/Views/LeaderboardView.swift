import SwiftUI

struct LeaderboardView: View {
    let leaderboardData: [LeaderboardEntry]
    let playerScore: Int
    @Binding var showLeaderboard: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Leaderboard")
                .font(.largeTitle)
                .padding()
            
            List(leaderboardData) { entry in
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
                showLeaderboard = false

            }) {
                Text("Main Menu")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}
struct LeaderboardEntry: Identifiable, Codable {
    let id: UUID
    let name: String
    let score: Int
}
