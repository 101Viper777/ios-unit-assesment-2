import SwiftUI

struct GameView: View {
    // Game settings
    @State var gameTimeLimit: Int
    @State var maxBalloons: Int
    @Binding var showLeaderboard: Bool

    // Game state
    @State var playerName: String
    @Binding var playerScore: Int
    @State var score = 0
    @State var gameTimeRemaining: Int
    @State private var gameTimer: Timer?
    private let totalGameTime: Int
    @State private var lastPoppedColor: Color? = nil

    // Bubbles
    @State var bubbles: [Bubble] = []
    private let colors = [
        Color.red: (points: 1, probability: 40),
        Color.pink: (points: 2, probability: 30),
        Color.green: (points: 5, probability: 15),
        Color.blue: (points: 8, probability: 10),
        Color.black: (points: 10, probability: 5)
    ]

    // For tracking consecutive pops
    @State private var consecutivePopCount = 0
    private let maxBubbles: Int

    init(playerName: String, gameTimeLimit: Int = 60, maxBalloons: Int = 15, playerScore: Binding<Int>, showLeaderboard: Binding<Bool>) {
        self.playerName = playerName
        self.gameTimeLimit = gameTimeLimit
        self.maxBalloons = maxBalloons
        self.gameTimeRemaining = gameTimeLimit
        self.totalGameTime = gameTimeLimit
        self.maxBubbles = maxBalloons
        self._playerScore = playerScore
        self._showLeaderboard = showLeaderboard
    }

    var body: some View {
        @Environment(\.presentationMode) var presentationMode

            ZStack {
                VStack {
                    HStack {
                       
                        
                        Text("Score: \(score)")
                        
                        Spacer()
                        
                        Text("Time: \(gameTimeRemaining)")
                    }
                    .padding()

                    Spacer()

                    ZStack {
                        ForEach(bubbles) { bubble in
                            BubbleView(bubble: bubble)
                                .onTapGesture {
                                    popBubble(bubble: bubble)
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    Spacer()
                }
                .padding()
                .onAppear {
                    startGame()
                }
            }
            .navigationBarHidden(true)
            .navigationBarItems(trailing: NavigationLink(destination: LeaderboardView(leaderboardData: getLeaderboardData(), playerScore: playerScore, showLeaderboard: $showLeaderboard), isActive: $showLeaderboard) {
                EmptyView()
            })
        }
    

    func startGame() {
        score = 0
        gameTimeRemaining = gameTimeLimit
        lastPoppedColor = nil
        consecutivePopCount = 0
        refreshBubbles()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            gameTick()
        }
    }

    private func gameTick() {
        if gameTimeRemaining > 0 {
            gameTimeRemaining -= 1
            refreshBubbles()
        } else {
            endGame()
        }
    }

    func popBubble(bubble: Bubble) {
        if lastPoppedColor == bubble.color {
            consecutivePopCount += 1
            score += Int(Double(bubble.points) * 1.5)
        } else {
            consecutivePopCount = 1
            score += bubble.points
        }
        lastPoppedColor = bubble.color
        bubbles.removeAll(where: { $0.id == bubble.id })
    }
    private func endGame() {
        gameTimer?.invalidate()
        playerScore = score
        updateLeaderboard()
        showLeaderboard = true
    }

    private func refreshBubbles() {
        // Remove some bubbles randomly
        bubbles.removeAll(where: { _ in Bool.random() })

        // Generate new bubbles until the maximum number is reached
        while bubbles.count < maxBubbles {
            let newBubble = generateRandomBubble()
            bubbles.append(newBubble)
        }
    }

    private func generateRandomBubble() -> Bubble {
        var position = CGPoint(x: 0, y: 0)
        var isOverlapping = true

        while isOverlapping {
            position = CGPoint(
                x: CGFloat.random(in: 30...UIScreen.main.bounds.width - 70),
                y: CGFloat.random(in: 10...UIScreen.main.bounds.height - 210)
            )

            isOverlapping = bubbles.contains { bubble in
                let dx = bubble.position.x - position.x
                let dy = bubble.position.y - position.y
                let distance = sqrt(dx * dx + dy * dy)
                return distance < 60 // Adjust this value based on the bubble size
            }
        }

        // Calculate the total probability space
        let totalProbability = colors.values.reduce(0) { $0 + $1.probability }

        // Generate a random point in this space
        var randomPoint = Int.random(in: 0..<totalProbability)

        // Determine which color this point falls into
        for (color, attributes) in colors {
            if randomPoint < attributes.probability {
                // Create and return a bubble with this color, points value, and position
                return Bubble(color: color, points: attributes.points, position: position)
            }
            randomPoint -= attributes.probability
        }

        // Fallback in case the loop does not return, should not happen
        return Bubble(color: .red, points: 1, position: position) // Default to a red bubble if something goes wrong
    }

    private func updateLeaderboard() {
        // Update the leaderboard data with the player's score
        var leaderboardData = getLeaderboardData()
        leaderboardData.append(LeaderboardEntry(id: UUID(), name: playerName, score: score))
        leaderboardData.sort { $0.score > $1.score }

        // Keep only the top 10 scores
        leaderboardData = Array(leaderboardData.prefix(10))

        // Save the updated leaderboard data
        let encodedData = try? JSONEncoder().encode(leaderboardData)
        UserDefaults.standard.set(encodedData, forKey: "LeaderboardData")
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

// For previewing in Xcode
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(playerName: "Test Player", playerScore: .constant(0), showLeaderboard: .constant(false))
    }
}
