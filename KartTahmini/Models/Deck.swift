//
//  Deck.swift
//  KartTahmini
//
//  Created by Sedanur Kırcı on 16.12.2025.
//

import Foundation

struct Deck {
    private(set) var cards: [Card]
    
    init() {
        var newDeck: [Card] = []
        
        for suit in Suit.allCases {
            for rank in Rank.allCases {
                newDeck.append(Card(suit: suit, rank: rank))
            }
        }
        
        self.cards = newDeck.shuffled()
    }
    
    mutating func drawCard() -> Card? {
        guard !cards.isEmpty else { return nil }
        return cards.removeFirst()
    }
}
