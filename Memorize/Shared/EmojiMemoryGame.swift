//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Bridger Hildreth on 4/15/22.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Game = MemoryGame<String>
    typealias Card = Game.Card
    
    @Published var theme: Theme {
        didSet {
            startNewGame()
        }
    }
    
    
    
    @Published private var model: Game

    
    init(theme: Theme) {
        self.theme = theme
        self.model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    static func createMemoryGame(theme: Theme) -> Game {
        let shuffledEmojis = theme.emojis.shuffled()
        var numberOfPairsOfCards: Int?
        if theme.numberOfPairs <= theme.emojis.count {
            numberOfPairsOfCards = theme.numberOfPairs
        } else {
            numberOfPairsOfCards = theme.emojis.count
        }

        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairsOfCards!) { pairIndex in
            shuffledEmojis[pairIndex]
        }
    }
    
    var cards: Array<Card> {
        return model.cards
    }
    
    var score: Int {
        return model.score
    }
    
    var themeName: String {
        theme.name
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func startNewGame() {
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
}
