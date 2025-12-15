//
//  JoinGameView.swift
//  KartTahmini
//
//  Created by Sedanur Kırcı on 16.12.2025.
//
import SwiftUI
import FirebaseAuth

struct JoinGameView: View {

    @State private var roomCode = ""
    @State private var isJoining = false
    @State private var joinSuccess = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 24) {

            Text("Koda Katıl")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("Oda Kodu", text: $roomCode)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .multilineTextAlignment(.center)
                .font(.title)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .onChange(of: roomCode) { newValue in
                    roomCode = newValue.uppercased().replacingOccurrences(of: " ", with: "")
                }

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

            Button {
                joinGame()
            } label: {
                if isJoining {
                    ProgressView()
                } else {
                    Text("Katıl")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                }
            }
            .disabled(roomCode.count != 4)

            NavigationLink("", destination: GameView(), isActive: $joinSuccess)

            Spacer()
        }
        .padding()
    }

    private func joinGame() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        isJoining = true
        errorMessage = nil

        FirebaseService.shared.joinGameRoom(
            roomCode: roomCode,
            guestId: userId
        ) { success in
            isJoining = false
            if success {
                joinSuccess = true
            } else {
                errorMessage = "Odaya katılamadı."
            }
        }
    }
}
