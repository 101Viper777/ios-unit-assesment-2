//
//  mainBubbleView.swift
//  ass2
//
//  Created by AbdulaIziz El sabbagh on 19/4/2024.
//

import SwiftUI

struct mainBubbleView: View {
    // State property for bubble position
    @State private var bubblePosition = CGPoint(x: 0, y: UIScreen.main.bounds.height)
    
    var body: some View {
        GeometryReader { geometry in
            // Circle representing the bubble
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 50, height: 50)
                .position(bubblePosition)
                .onAppear {
                    // Generate a random X position within the screen width
                    let randomX = Double.random(in: 0...geometry.size.width)
                    bubblePosition = CGPoint(x: randomX, y: geometry.size.height)
                    
                    // Animate the bubble moving upwards with a linear animation
                    withAnimation(Animation.linear(duration: 3).repeatForever(autoreverses: false)) {
                        bubblePosition = CGPoint(x: randomX, y: 0)
                    }
                }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct mainBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        mainBubbleView()
    }
}
