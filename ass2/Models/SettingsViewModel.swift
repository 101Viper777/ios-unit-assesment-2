//
//  SettingsViewModel.swift
//  ass2
//
//  Created by AbdulaIziz El sabbagh on 18/4/2024.
//
import SwiftUI
class SettingsViewModel: ObservableObject {
    @Published var gameTimeLimit: Double {
        didSet {
            UserDefaults.standard.set(gameTimeLimit, forKey: "GameTimeLimit")
        }
    }
    
    @Published var maxBalloons: Double {
        didSet {
            UserDefaults.standard.set(maxBalloons, forKey: "MaxBalloons")
        }
    }
    
    init() {
        self.gameTimeLimit = Double(UserDefaults.standard.integer(forKey: "GameTimeLimit"))
        self.maxBalloons = Double(UserDefaults.standard.integer(forKey: "MaxBalloons"))
    }
    
    func saveSettings() {
        UserDefaults.standard.set(Int(gameTimeLimit), forKey: "GameTimeLimit")
        UserDefaults.standard.set(Int(maxBalloons), forKey: "MaxBalloons")
    }
}
