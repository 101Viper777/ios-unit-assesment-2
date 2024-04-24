//
//  mainBubbleView.swift
//  ass2
//
//  Created by AbdulaIziz El sabbagh on 24/4/2024.
//
import SwiftUI

struct mainBubbleView: View {
    @State private var bubblePosition = CGPoint(x: 0, y: UIScreen.main.bounds.height)
    
    var body: some View {
        GeometryReader { geometry in
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 50, height: 50)
                .position(bubblePosition)
                .onAppear {
                    let randomX = Double.random(in: 0...geometry.size.width)
                    bubblePosition = CGPoint(x: randomX, y: geometry.size.height)
                    
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
