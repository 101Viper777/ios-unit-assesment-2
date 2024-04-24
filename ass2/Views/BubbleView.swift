//
//  BubbleView.swift
//  ass2
//
//  Created by AbdulaIziz El sabbagh on 12/4/2024.
//

// Importing SwiftUI framework
import SwiftUI

struct BubbleView: View {
    // Bubble model representing the properties of the bubble
    let bubble: Bubble
    
    var body: some View {
        // Circle shape representing the bubble
        Circle()
            // Fill color based on bubble's color
            .fill(bubble.color)
            // Fixed size for the bubble
            .frame(width: 60, height: 60)
            // Overlay text displaying points inside the bubble
            .overlay(
                Text("\(bubble.points)")
                    .foregroundColor(.white)
                    .font(.headline)
            )
            // Positioning the bubble using its position property
            .position(x: bubble.position.x, y: bubble.position.y)
            // Applying animation for visual effects
            .animation(.default)
    }
}

struct BubbleView_Previews: PreviewProvider {
    static var previews: some View {
        BubbleView(bubble: Bubble(color: .red, points: 1, position: CGPoint(x: 100, y: 100)))
    }
}
