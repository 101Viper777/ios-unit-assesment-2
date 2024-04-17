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
            VStack {
                Spacer()
                Text("BubblePop game")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)

                TextField("Enter your name", text: $playerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                NavigationLink(destination: GameView(showLeaderboard: $showLeaderboard, showGameView: $showGameView, playerName: $playerName), isActive: $showGameView) {

        
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
                                  showLeaderboard = true
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
                              .sheet(isPresented: $showLeaderboard) {
                                  LeaderboardView(leaderboardViewModel: leaderboardViewModel, playerScore: $playerScore, showGameView: $showGameView)
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
                    SettingsView()
                }

                Spacer()
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
