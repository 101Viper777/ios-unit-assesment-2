//
//  CountdownView.swift
//  ass2
//
//  Created by AbdulaIziz El sabbagh on 23/4/2024.
//

import SwiftUI

struct CountdownView: View {
    @Binding var showCountdown: Bool
    @State private var countdownTimer: Timer?
    @State private var countdownValue = 3
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            
            Text("\(countdownValue)")
                .font(.system(size: 100, weight: .bold))
                .foregroundColor(.white)
                .opacity(countdownValue > 0 ? 1 : 0)
            
            Text("Start")
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(.white)
                .opacity(countdownValue == 0 ? 1 : 0)
        }
        .onAppear {
            startCountdown()
        }
    }
    
    private func startCountdown() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            countdownValue -= 1
            if countdownValue == 0 {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showCountdown = false
                }
            }
        }
    }
}

//#Preview {
//    CountdownView(showCountdown: <#Binding<Bool>#>)
//}
