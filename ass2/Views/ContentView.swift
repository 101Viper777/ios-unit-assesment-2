import SwiftUI

struct ContentView: View {
    @State private var playerName: String = ""
    @State private var navigateToGameView: Bool = false
    @State private var gameTimeLimit: Int = 60 //defuault vals
    @State private var maxBalloons: Int = 15 //default values .,
    @State private var showAlert: Bool = false

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

                
                NavigationLink(
                    destination: GameView(
                        viewModel: GameViewModel(
                            playerName: playerName,
                            gameTimeLimit: gameTimeLimit,
                            maxBalloons: maxBalloons
                        )
                    )
                ) {
                    Text("Start Game")
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .padding(.horizontal)
                }
                .disabled(playerName.isEmpty)
                
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text("Please enter your name to start the game."),
                        dismissButton: .default(Text("OK"))
                    )
                }

                NavigationLink(destination: SettingsView(gameTimeLimit: $gameTimeLimit, maxBalloons: $maxBalloons)) {
                    Text("Settings")
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.gray, Color.black]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .padding(.horizontal)
                }
                .padding()
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
