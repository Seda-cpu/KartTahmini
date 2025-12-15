//
//  Suit.swift
//  KartTahmini
//
//  Created by Sedanur Kırcı on 16.12.2025.
//

import Foundation

enum Suit:  String, CaseIterable {
    case spades = "♠︎"
    case hearts = "♥︎"
    case clubs = "♣︎"
    case diamonds = "♦︎"
    
    var name: String {
        switch self {
        case .spades:
            return "Spades"
        case .hearts:
            return "Hearts"
        case .clubs:
            return "Clubs"
        case .diamonds:
            return "Diamonds"
        }
    }
}
