//
//  BubbleView.swift
//  ass2
//
//  Created by AbdulaIziz El sabbagh on 16/4/2024.
//
import SwiftUI

struct BubbleView: View {
    let bubble: Bubble
    
    var body: some View {
        Circle()
            .fill(bubble.color)
            .frame(width: 60, height: 60)
            .overlay(
                Text("\(bubble.points)")
                    .foregroundColor(.white)
                    .font(.headline)
            )
            .position(x: bubble.position.x, y: bubble.position.y)
            .animation(.default)
    }
}

struct BubbleView_Previews: PreviewProvider {
    static var previews: some View {
        BubbleView(bubble: Bubble(color: .red, points: 1, position: CGPoint(x: 100, y: 100)))
    }
}
