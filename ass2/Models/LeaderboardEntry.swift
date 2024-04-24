//
//  LeaderboardEntry.swift
//  ass2
//
//  Created by AbdulaIziz El sabbagh on 14/4/2024.
//

import Foundation

struct LeaderboardEntry: Identifiable, Codable {
    let id: UUID
    let name: String
    let score: Int
}
