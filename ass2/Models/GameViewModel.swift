//
//  GameViewModel.swift
//  ass2
//
//  Created by AbdulaIziz El sabbagh on 3/4/2024.
//
import Foundation
import SwiftUI
import Combine
class GameViewModel: ObservableObject {
    // Game settings
    @Published var gameTimeLimit: Int
    @Published var maxBalloons: Int

    // Game state
    @Published var playerName: String
    @Published var score = 0
    @Published var gameTimeRemaining: Int
    private var gameTimer: Timer?
    private let totalGameTime: Int
    private var lastPoppedColor: Color? = nil

    // Bubbles
    @Published var bubbles: [Bubble] = []
    private let colors = [
        Color.red: (points: 1, probability: 40),
        Color.pink: (points: 2, probability: 30),
        Color.green: (points: 5, probability: 15),
        Color.blue: (points: 8, probability: 10),
        Color.black: (points: 10, probability: 5)
    ]

    // For tracking consecutive pops
    private var consecutivePopCount = 0
    private let maxBubbles: Int

    init(playerName: String, gameTimeLimit: Int = 60, maxBalloons: Int = 15) {
        self.playerName = playerName
        self.gameTimeLimit = gameTimeLimit
        self.maxBalloons = maxBalloons
        self.gameTimeRemaining = gameTimeLimit
        self.totalGameTime = gameTimeLimit
        self.maxBubbles = maxBalloons
    }

    func startGame() {
        score = 0
        gameTimeRemaining = gameTimeLimit
        lastPoppedColor = nil
        consecutivePopCount = 0
        refreshBubbles()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.gameTick()
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

        // Remove the popped bubble and possibly refresh bubbles depending on your game design
    }
    
    private func endGame() {
        gameTimer?.invalidate()
        // Handle end of game, such as saving scores, showing end screen, etc.
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
   }


// Bubble.swift
struct Bubble: Identifiable {
    let id = UUID()
    let color: Color
    let points: Int
    let position: CGPoint // Add position property
}
