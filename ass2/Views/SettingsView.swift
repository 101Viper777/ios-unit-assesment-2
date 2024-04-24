//
//  SettingsView.swift
//  ass2
//
//  Created by AbdulaIziz El sabbagh on 08/4/2024.
//


import SwiftUI

struct SettingsView: View {
    // Settings view model for managing settings
    @ObservedObject var settingsViewModel = SettingsViewModel()
    // Environment variable for managing presentation mode
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        // Navigation view for nav related functionality
        NavigationView {
            VStack {
                Form {
                    // Section for game settings
                    Section(header: Text("Game Settings").font(.headline).foregroundColor(.primary)) {
                        // Slider for setting game time limit
                        HStack {
                            Text("Game Time Limit")
                            Spacer()
                            Text("\(Int(settingsViewModel.gameTimeLimit)) seconds").foregroundColor(.secondary)
                        }
                        Slider(value: $settingsViewModel.gameTimeLimit, in: 1...120).accentColor(.orange)
                        
                        // Slider for setting maximum balloons
                        HStack {
                            Text("Max Balloons")
                            Spacer()
                            Text("\(Int(settingsViewModel.maxBalloons))").foregroundColor(.secondary)
                        }
                        Slider(value: $settingsViewModel.maxBalloons, in: 1...25).accentColor(.orange)
                    }
                }
                
                Spacer()
                
                // Button for saving settings
                Button(action: {
                    settingsViewModel.saveSettings()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save").foregroundColor(.white).padding().background(Color.orange).cornerRadius(10)
                }
                .padding()
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
