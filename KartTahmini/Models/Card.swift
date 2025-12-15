//
//  Card.swift
//  KartTahmini
//
//  Created by Sedanur Kırcı on 16.12.2025.
//

import Foundation

struct Card: Identifiable {
    let id = UUID()
    let suit: Suit
    let rank: Rank
}
