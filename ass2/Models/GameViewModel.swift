//
//  GameViewModel.swift
//  ass2
//
//  Created by AbdulaIziz El sabbagh on 18/4/2024.
//
import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var bubbles: [Bubble] = []
    @Published var score = 0
    @Published var gameTimeRemaining: Int
    @Binding var playerScore: Int
    @Published var showLeaderboard = false
    @Binding var showGameView: Bool

    private let totalGameTime: Int
    private let maxBubbles: Int
    private var gameTimer: Timer?
    private var lastPoppedColor: Color? = nil
    private var consecutivePopCount = 0
    private let playerName: String
    
    private let colors = [
        Color.red: (points: 1, probability: 40),
        Color.pink: (points: 2, probability: 30),
        Color.green: (points: 5, probability: 15),
        Color.blue: (points: 8, probability: 10),
        Color.black: (points: 10, probability: 5)
    ]

    init(playerName: String, playerScore: Binding<Int>, showGameView: Binding<Bool>) {
        self.playerName = playerName
        self._playerScore = playerScore
        self._showGameView = showGameView
        self.maxBubbles = UserDefaults.standard.integer(forKey: "MaxBalloons")
        self.totalGameTime = UserDefaults.standard.integer(forKey: "GameTimeLimit")
        self.gameTimeRemaining = self.totalGameTime
    }
    
    func startGame() {
        score = 0
        gameTimeRemaining = totalGameTime
        lastPoppedColor = nil
        consecutivePopCount = 0
        refreshBubbles()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.gameTick()
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
        showGameView = false

    }
    private func refreshBubbles() {
        bubbles.removeAll(where: { _ in Bool.random() })
        
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
                return distance < 60
            }
        }
        
        let totalProbability = colors.values.reduce(0) { $0 + $1.probability }
        var randomPoint = Int.random(in: 0..<totalProbability)
        
        for (color, attributes) in colors {
            if randomPoint < attributes.probability {
                return Bubble(color: color, points: attributes.points, position: position)
            }
            randomPoint -= attributes.probability
        }
        
        return Bubble(color: .red, points: 1, position: position)
    }
    
    private func updateLeaderboard() {
        LeaderboardViewModel.shared.addEntry(name: playerName, score: score)
    }
}
