//
//  GameState.swift
//  KartTahmini
//
//  Created by Sedanur Kırcı on 16.12.2025.
//

import Foundation

struct GameState {
    var deck: Deck
    var currentRound: Int = 1
    let totalRounds: Int = 6
    
    var history: [RoundResult] = []
    
    init() {
        self.deck = Deck()
    }
    
    var isGameOver: Bool {
        currentRound > totalRounds
    }
        
    mutating func reveal(prediction: Prediction, pointsCalculator: (Prediction, Card) -> Int) {
        guard !isGameOver else { return }
        guard let card = deck.drawCard() else { return }
        
        let earned = pointsCalculator(prediction, card)
        let result = RoundResult(
            roundIndex: currentRound,
            prediction: prediction,
            revealedCard: card,
            pointsEarned: earned
        )
        
        history.append(result)
        currentRound += 1
    }

}
