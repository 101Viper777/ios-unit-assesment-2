import SwiftUI

// View for displaying the leaderboard
struct LeaderboardView: View {
    // View model for managing leaderboard data
    @ObservedObject var leaderboardViewModel: LeaderboardViewModel
    // Binding for the player's score
    @Binding var playerScore: Int
    // Environment variable for managing presentation mode
    @Environment(\.presentationMode) var presentationMode
    // Binding for controlling whether to show the game view
    @Binding var showGameView: Bool
    
    // Body of the LeaderboardView
    var body: some View {
        // Navigation view for navigation-related functionality
        NavigationView {
            // ZStack for layering views
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [Color.green, Color.indigo]), startPoint: .leading, endPoint: .trailing)
                    .edgesIgnoringSafeArea(.all)
                
                // Main content VStack
                VStack {
                    // List displaying leaderboard entries
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
                    
                    // View displaying the player's final score
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
                    
                    // Button for resetting the leaderboard
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
                .navigationBarTitle("Leaderboard", displayMode: .inline) // Navigation bar title
                .onAppear {
                    leaderboardViewModel.getLeaderboardData() // Fetch leaderboard data on view appear
                }
            }
        }
    }
}

// Preview provider for LeaderboardView
struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        // Creating a sample leaderboard view for preview
        let leaderboardViewModel = LeaderboardViewModel()
        leaderboardViewModel.leaderboardData = [
            LeaderboardEntry(id: UUID(), name: "Player 1", score: 100),
            LeaderboardEntry(id: UUID(), name: "Player 2", score: 90),
            LeaderboardEntry(id: UUID(), name: "Player 3", score: 80),
            LeaderboardEntry(id: UUID(), name: "Player 4", score: 70),
            LeaderboardEntry(id: UUID(), name: "Player 5", score: 60)
        ]
        
        // Returning the leaderboard view for preview
        return LeaderboardView(leaderboardViewModel: leaderboardViewModel, playerScore: .constant(85), showGameView: .constant(false))
    }
}
