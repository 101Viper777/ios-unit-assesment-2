//
//  SettingsView.swift
//  ass2
//
//  Created by AbdulaIziz El sabbagh on 2/4/2024.
//

import SwiftUI

struct SettingsView: View {
    @Binding var gameTimeLimit: Int
    @Binding var maxBalloons: Int
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showSavedPopup = false
    
    var body: some View {
        ZStack{
        VStack(alignment: .leading, spacing: 20) {
            Text("Game Settings")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Time Limit")
                    .fontWeight(.semibold)
                
                HStack {
                    Slider(value: Binding(
                        get: { Double(gameTimeLimit) },
                        set: { gameTimeLimit = Int($0) }
                    ), in: 10...120, step: 1)
                    Text("\(gameTimeLimit) sec")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Max Balloons")
                    .fontWeight(.semibold)
                
                HStack {
                    Slider(value: Binding(
                        get: { Double(maxBalloons) },
                        set: { maxBalloons = Int($0) }
                    ), in: 1...25, step: 1)
                    Text("\(maxBalloons)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            

            Button(action: {
                showSavedPopup = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showSavedPopup = false
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)

        if showSavedPopup {
            ZStack {
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.green)
                    Text("Settings Saved")
                        .font(.headline)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .transition(.scale)
            }
        }
    }
}
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(gameTimeLimit: .constant(60), maxBalloons: .constant(15))
    }
}
