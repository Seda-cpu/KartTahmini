//
//  RoomCodeGenerator.swift
//  KartTahmini
//
//  Created by Sedanur Kırcı on 16.12.2025.
//

import Foundation

struct RoomCodeGenerator {
    static func generate() -> String {
        let letters = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
        return String((0..<4).compactMap { _ in letters.randomElement() })
    }
}
