//
//  CountdownView.swift
//  ass2
//
//  Created by AbdulaIziz El sabbagh on 17/4/2024.
//

import SwiftUI

struct CountdownView: View {
    // Binding to control the visibility of the countdown view
    @Binding var showCountdown: Bool
    
    // Properties for countdown timer
    @State private var countdownTimer: Timer?
    @State private var countdownValue = 3
    
    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            
            // Countdown text
            Text("\(countdownValue)")
                .font(.system(size: 100, weight: .bold))
                .foregroundColor(.white)
                .opacity(countdownValue > 0 ? 1 : 0)
            
            // "Start" text after countdown finishes
            Text("Start")
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(.white)
                .opacity(countdownValue == 0 ? 1 : 0)
        }
        .onAppear {
            // Start the countdown when the view appears
            startCountdown()
        }
    }
    
    // Function to start the countdown timer
    private func startCountdown() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            countdownValue -= 1
            if countdownValue == 0 {
                // Stop the timer and hide the countdown view after countdown finishes
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showCountdown = false
                }
            }
        }
    }
}
