//
//  ContentView.swift
//  Shared
//
//  Created by Bridger Hildreth on 4/15/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.theme.name)
                    .foregroundColor(viewModel.theme.color)
                Spacer()
                Button(
                    action:
                        viewModel.startNewGame
                    , label: {
                        Text("New")
                    })
            }
            .font(.title2)
            Group {
                Text("Score: \(viewModel.score) points").font(.body)
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                        ForEach(viewModel.cards) { card in
                            CardView(card: card).aspectRatio(2/3, contentMode: .fit)
                                .onTapGesture {
                                    viewModel.choose(card)
                                }
                        }
                    }
                }
            }
            .foregroundColor(viewModel.theme.color)
        }
        .font(.largeTitle)
        .padding(.horizontal)
    }
}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
                shape.opacity(0)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                shape.fill()
            }
        }
    }
}

