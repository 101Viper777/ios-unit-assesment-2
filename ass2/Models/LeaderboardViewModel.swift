//
//  LeaderboardViewModel.swift
//  ass2
//
//  Created by AbdulaIziz El sabbagh on 18/4/2024.
//
import SwiftUI

class LeaderboardViewModel: ObservableObject {
    @Published var leaderboardData: [LeaderboardEntry] = []
    
    static let shared = LeaderboardViewModel()
    
    init() {
        getLeaderboardData()
    }
    
    func getLeaderboardData() {
        if let data = UserDefaults.standard.data(forKey: "LeaderboardData"),
           let leaderboardData = try? JSONDecoder().decode([LeaderboardEntry].self, from: data) {
            self.leaderboardData = leaderboardData
        }
    }
    
    func addEntry(name: String, score: Int) {
        let newEntry = LeaderboardEntry(id: UUID(), name: name, score: score)
        leaderboardData.append(newEntry)
        leaderboardData.sort { $0.score > $1.score }
        leaderboardData = Array(leaderboardData.prefix(10))
        saveLeaderboardData()
    }
    func getHighestScore() -> Int {
        // Retrieve the highest score from the leaderboard
        let highestScore = leaderboardData.max(by: { $0.score < $1.score })?.score ?? 0
        return highestScore
    }
    private func saveLeaderboardData() {
        let encodedData = try? JSONEncoder().encode(leaderboardData)
        UserDefaults.standard.set(encodedData, forKey: "LeaderboardData")
    }
}
 
