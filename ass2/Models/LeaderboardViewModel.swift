//
//  LeaderboardViewModel.swift
//  ass2
//
//  Created by AbdulaIziz El sabbagh on 10/4/2024.
//

import SwiftUI

class LeaderboardViewModel: ObservableObject {
    // Published property to update the UI
    @Published var leaderboardData: [LeaderboardEntry] = []
    
    // Singleton instance
    static let shared = LeaderboardViewModel()
    
    init() {
        // Initialize and retrieve leaderboard data
        getLeaderboardData()
    }
    
    // Retrieves leaderboard data from UserDefaults
    func getLeaderboardData() {
        if let data = UserDefaults.standard.data(forKey: "LeaderboardData"),
           let leaderboardData = try? JSONDecoder().decode([LeaderboardEntry].self, from: data) {
            self.leaderboardData = leaderboardData
        }
    }
    
    // Adds a new entry to the leaderboard and updates it
    func addEntry(name: String, score: Int) {
        let newEntry = LeaderboardEntry(id: UUID(), name: name, score: score)
        leaderboardData.append(newEntry)
        leaderboardData.sort { $0.score > $1.score }
        if leaderboardData.count > 10 {
            leaderboardData = Array(leaderboardData.prefix(10))
        }
        saveLeaderboardData()
    }
    
    // Resets the leaderboard
    func resetLeaderboard() {
        leaderboardData.removeAll()
        saveLeaderboardData()
    }
    
    // Retrieves the highest score from the leaderboard
    func getHighestScore() -> Int {
        let highestScore = leaderboardData.max(by: { $0.score < $1.score })?.score ?? 0
        return highestScore
    }
    
    // Saves the leaderboard data to UserDefaults
    private func saveLeaderboardData() {
        let encodedData = try? JSONEncoder().encode(leaderboardData)
        UserDefaults.standard.set(encodedData, forKey: "LeaderboardData")
    }
}
