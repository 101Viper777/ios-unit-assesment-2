import SwiftUI

struct ContentView: View {
    @State private var playerName: String = ""
    @State private var showGameView = false
    @State private var showLeaderboardView = false
    @State private var showSettingsView = false
    @State private var gameTimeLimit: Int = 5 // default value
    @State private var maxBalloons: Int = 15 // default value
    @State private var showAlert: Bool = false
    @State private var playerScore = 0
    @State private var showLeaderboard = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("BubblePop Game")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)

                TextField("Enter your name", text: $playerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                NavigationLink(destination: GameView(playerName: playerName, gameTimeLimit: gameTimeLimit, maxBalloons: maxBalloons, playerScore: $playerScore, showLeaderboard: $showLeaderboard), isActive: $showGameView) {
                    Button(action: {
                        if playerName.isEmpty {
                            showAlert = true
                        } else {
                            showGameView = true
                        }
                    }) {
                        Text("Start Game")
                            .bold()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(40)
                            .padding(.horizontal)
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text("Please enter your name to start the game."),
                        dismissButton: .default(Text("OK"))
                    )
                }

                Button(action: {
                    showLeaderboardView = true
                }) {
                    Text("Leaderboard")
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.gray, Color.black]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .padding(.horizontal)
                }
                .fullScreenCover(isPresented: $showLeaderboardView) {
                    LeaderboardView(leaderboardData: getLeaderboardData(), playerScore: playerScore, showLeaderboard: $showLeaderboard)
                }

                Button(action: {
                    showSettingsView = true
                }) {
                    Text("Settings")
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.gray, Color.black]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .padding(.horizontal)
                }
                .fullScreenCover(isPresented: $showSettingsView) {
                    SettingsView(gameTimeLimit: $gameTimeLimit, maxBalloons: $maxBalloons)
                }

                Spacer()
            }
            .padding()
        }
    }

    private func getLeaderboardData() -> [LeaderboardEntry] {
        // Retrieve the leaderboard data from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "LeaderboardData"),
           let leaderboardData = try? JSONDecoder().decode([LeaderboardEntry].self, from: data) {
            return leaderboardData
        }
        return []
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
