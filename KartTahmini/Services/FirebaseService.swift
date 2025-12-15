//
//  FirebaseService.swift
//  KartTahmini
//
//  Created by Sedanur Kırcı on 16.12.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class FirebaseService {
    
    static let shared = FirebaseService()
    
    let db = Firestore.firestore()
    
    private init() {}
    
    func signInAnonymously(completion: @escaping (String?) -> Void) {
        if let user = Auth.auth().currentUser {
            completion(user.uid)
            return
        }
        
        Auth.auth().signInAnonymously { result, error in
            if let user = result?.user {
                completion(user.uid)
            } else {
                completion(nil)
            }
        }
    }
    
    
    func createGameRoom(hostId: String, completion: @escaping (String?) -> Void) {
        
        let roomCode = RoomCodeGenerator.generate()
        
        // 6 round için 6 kart çekelim
        let deck = Deck()
        let cards = Array(deck.cards.prefix(6)).map {
            [
                "suit": $0.suit.name,
                "rank": $0.rank.rawValue
            ]
        }
        
        let data: [String: Any] = [
            "roomCode": roomCode,
            "status": "waiting",
            "createdAt": Timestamp(),
            "currentRound": 1,
            "totalRounds": 6,
            "deck": cards,
            "players": [
                "host": [
                    "id": hostId,
                    "score": 0
                ]
            ]
        ]
        
        db.collection("gameRooms")
            .document(roomCode)
            .setData(data) { error in
                if error == nil {
                    completion(roomCode)
                } else {
                    completion(nil)
                }
            }
    }
    
    func joinGameRoom(roomCode: String, guestId: String, completion: @escaping (Bool) -> Void) {

        let ref = db.collection("gameRooms").document(roomCode)

        ref.getDocument { snapshot, error in
            guard
                let data = snapshot?.data(),
                error == nil,
                let players = data["players"] as? [String: Any]
            else {
                completion(false)
                return
            }

            // Zaten guest varsa alma
            if players["guest"] != nil {
                completion(false)
                return
            }

            ref.updateData([
                "players.guest": [
                    "id": guestId,
                    "score": 0
                ],
                "status": "playing"
            ]) { error in
                completion(error == nil)
            }
        }
    }


}
