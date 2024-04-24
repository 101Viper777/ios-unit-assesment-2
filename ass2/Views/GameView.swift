//
//  GameView.swift
//  ass2
//
//  Created by AbdulaIziz El sabbagh on 05/4/2024.
//

// Importing necessary libraries
import SwiftUI
import AVFoundation

// Structure representing the game view
struct GameView: View {
    
    // State object for managing game-related data
    @StateObject private var gameViewModel: GameViewModel
    // State variable for managing audio playback
    @State private var audioPlayer: AVAudioPlayer?
    // Binding variables for managing navigation states
    @Binding var showLeaderboard: Bool
    @Binding var showGameView: Bool
    @Binding var playerName: String
    // State variables for managing game-related states
    @State private var showCountdown = true
    @State private var consecutivePopCount = 0
    @State private var hasBeatenHighScore = false
    
    // Constructor for initializing the GameView
    init(showLeaderboard: Binding<Bool>, showGameView: Binding<Bool>, playerName: Binding<String>) {
        self._showLeaderboard = showLeaderboard
        self._showGameView = showGameView
        self._playerName = playerName
        self._gameViewModel = StateObject(wrappedValue: GameViewModel(playerName: playerName.wrappedValue, showGameView: showGameView))
    }
    
    // Body of the GameView
    var body: some View {
        // Closure for defining score color based on progress
        var scoreColor: Color {
            let progress = min(1.0, Double(gameViewModel.score) / Double(gameViewModel.highestScore))
            return interpolate(from: Color.white, to: Color(red: 1.0, green: 0.84, blue: 0.0), amount: progress)
        }
        
        // Main content stack
        ZStack {
            // Display combo count if it's greater than 1
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
            
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.purple]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            // Main content VStack
            VStack {
                // Top row containing score, time, and high score
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
                    
                    // Displaying high score with a crown icon if the current score beats the highest score
                    VStack {
                        ZStack {
                            Text("High Score: \(gameViewModel.highestScore)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0))
                            
                            if gameViewModel.score >= gameViewModel.highestScore {
                                Image(systemName: "crown")
                                    .foregroundColor(.yellow)
                                    .offset(y: -20)
                                    .onAppear {
                                        playSound()
                                    }
                            }
                        }
                    }
                }
                .padding()
                
                Spacer()
                
                // Bubble grid
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
            
            // Countdown view
            if showCountdown {
                CountdownView(showCountdown: $showCountdown)
                    .transition(.opacity)
            }
        }
        .onAppear {
            // Start the game and prepare the sound
            gameViewModel.startGame()
            prepareSound()
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $gameViewModel.showLeaderboard) {
            // Present leaderboard view
            LeaderboardView(leaderboardViewModel: LeaderboardViewModel(), playerScore: $gameViewModel.playerScore, showGameView: $showGameView)
        }
    }
    
    // Function for playing sound
    func playSound() {
        audioPlayer?.play()
    }
    
    // Function for preparing sound
    func prepareSound() {
        guard let soundURL = Bundle.main.url(forResource: "high_score_sound", withExtension: "mp3") else {
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Error loading sound: \(error.localizedDescription)")
        }
    }
    
    // Function for interpolating between two colors
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

// Extension to extract color components
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

// Extension to clamp a value between a range
extension Double {
    func clamp(min: Double, max: Double) -> Double {
        return self < min ? min : (self > max ? max : self)
    }
}

// Preview provider for GameView
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(showLeaderboard: .constant(false), showGameView: .constant(true), playerName: .constant("Test Player"))
    }
}
