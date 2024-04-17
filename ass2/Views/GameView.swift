//
//  GameView.swift
//  ass2
//
//  Created by AbdulaIziz El sabbagh on 3/4/2024.
//
import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Score: \(viewModel.score)")
                    Spacer()
                    Text("Time: \(viewModel.gameTimeRemaining)")
                }
                .padding()
                
                Spacer()
                
                ZStack {
                    ForEach(viewModel.bubbles) { bubble in
                        BubbleView(bubble: bubble)
                            .onTapGesture {
                                viewModel.popBubble(bubble: bubble)
                            }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Spacer()
            }
            .padding()
            .onAppear {
                viewModel.startGame()
            }
        }
    }
}

// For previewing in Xcode
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: GameViewModel(playerName: "Test Player"))
    }
}
