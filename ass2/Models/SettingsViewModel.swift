//
//  SettingsViewModel.swift
//  ass2
//
//  Created by AbdulaIziz El sabbagh on 18/4/2024.
//
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var gameTimeLimit: Double = 60 // Set default value here
    @Published var maxBalloons: Double = 15 // Set default value here
    
    init() {
        // Load saved settings or use default values
        loadSettings()
    }
    
    func saveSettings() {
        UserDefaults.standard.set(gameTimeLimit, forKey: "GameTimeLimit")
        UserDefaults.standard.set(maxBalloons, forKey: "MaxBalloons")
    }
    
    private func loadSettings() {
        gameTimeLimit = UserDefaults.standard.double(forKey: "GameTimeLimit")
        maxBalloons = UserDefaults.standard.double(forKey: "MaxBalloons")
        
        // If no saved values exist, use the default values
        if gameTimeLimit == 0 {
            gameTimeLimit = 60
        }
        if maxBalloons == 0 {
            maxBalloons = 15
        }
    }
}
