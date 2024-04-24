//
//  SettingsViewModel.swift
//  ass2
//
//  Created by AbdulaIziz El sabbagh on 08/4/2024.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    // Published properties for game settings
    @Published var gameTimeLimit: Double = 60 // Default game time limit
    @Published var maxBalloons: Double = 15 // Default maximum number of balloons
    
    init() {
        // Load saved settings or use default values
        loadSettings()
    }
    
    // Saves current settings to UserDefaults
    func saveSettings() {
        UserDefaults.standard.set(gameTimeLimit, forKey: "GameTimeLimit")
        UserDefaults.standard.set(maxBalloons, forKey: "MaxBalloons")
    }
    
    // Loads settings from UserDefaults or sets default values
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
