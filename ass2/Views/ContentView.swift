import SwiftUI

struct ContentView: View {
    @StateObject private var leaderboardViewModel = LeaderboardViewModel()
    @State private var playerName: String = ""
    @State private var showGameView = false
    @State private var showLeaderboardView = false
    @State private var showSettingsView = false
    @State private var showAlert: Bool = false
    @State private var playerScore = 0
    @State private var showLeaderboard = false

    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer()

                    Text("BubblePop")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    TextField("Enter your name", text: $playerName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    NavigationLink(destination: GameView(showLeaderboard: $showLeaderboard, showGameView: $showGameView, playerName: $playerName), isActive: $showGameView) {
                        Button(action: {
                            if playerName.isEmpty {
                                showAlert = true
                            } else {
                                showGameView = true
                            }
                        }) {
                            Text("Start Game")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                     
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.purple]), startPoint: .leading, endPoint: .trailing))
                                )
                        }
                    }

                    Button(action: {
                        showLeaderboard = true
                    }) {
                        Text("Leaderboard")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color.green, Color.mint]), startPoint: .leading, endPoint: .trailing))
                            )
                    }
                    .sheet(isPresented: $showLeaderboard) {
                        LeaderboardView(leaderboardViewModel: leaderboardViewModel, playerScore: $playerScore, showGameView: $showGameView)
                    }

                    Button(action: {
                        showSettingsView = true
                    }) {
                        Text("Settings")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing))
                            )
                    }
                    .fullScreenCover(isPresented: $showSettingsView) {
                        SettingsView()
                    }

                    Spacer()
                }
                .padding()
            }
        }
        .accentColor(.white) // Change the accent color for better visibility
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text("Please enter your name to start the game."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
