//
//  RoundResult.swift
//  KartTahmini
//
//  Created by Sedanur Kırcı on 16.12.2025.
//

import Foundation

struct RoundResult: Identifiable {
    let id = UUID()
    let roundIndex: Int
    let prediction: Prediction
    let revealedCard: Card
    let pointsEarned: Int
}
