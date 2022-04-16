//
//  MemoryGame.swift
//  Memorize
//
//  Created by Bridger Hildreth on 4/15/22.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var score: Int = 0
    private(set) var cards: Array<Card>
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                }
                indexOfTheOneAndOnlyFaceUpCard = nil
            } else {
                for index in cards.indices {
                    if cards[index].isFaceUp && !cards[index].isMatched {
                        if cards[index].wasSeen {
                            score -= 1
                        }
                        cards[index].wasSeen = true
                    }
                    cards[index].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
        print("\(cards)")
    }
        
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    init(cardContents: [CardContent]) {
        var id: Int = 0
        cards = cardContents.reduce(into: .init(), {
            $0.append(.init(content: $1, id: id))
            id += 1
            $0.append(.init(content: $1, id: id))
            id += 1
        })
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
        fileprivate var wasSeen: Bool = false
    }
}
