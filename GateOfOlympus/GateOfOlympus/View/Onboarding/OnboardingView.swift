//
//  OnboardingView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("isOnboarding") var isUserLogin: Bool?
    @State private var currentTextIndex = 0
    private let feedback = UIImpactFeedbackGenerator(style: .soft)
    private let colors: [Color] = [.red, .yellow, .blue, .purple, .gray, .accentColor, .brown]
    private let texts = [
        "Set in an ancient world where gods control the elements and the destinies of mortals, God of Thunder is an epic game where players will control the power of the most powerful god of thunder",
        "The player begins his adventure by receiving tasks from the god himself to prove his durability and strength in solving various puzzles by matching rows of three or more elements representing celestial phenomena and artifacts of divine power.",
        "With each successful combination of elements, the player earns points and coins, allowing him to unlock new levels and challenges, each of which requires more ingenuity and strategy.",
        "A limited number of moves and time add tension and importance to each action, while bonuses and special powerful combinations help you overcome the most difficult stages.",
        "In addition, the player can participate in additional challenges that provide unique rewards and rare artifacts that enhance his abilities.",
        "These artifacts, found throughout the game, can be used to summon special magical effects or enhance moves, making each game unique.",
        "Thus, the game 'God of Thunder' turns into an exciting adventure, where every step brings the player closer to the status of a legendary hero, capable of controlling the elements along with the gods."
    ]
    
    var body: some View {
        let backgroundColor = colors[currentTextIndex % colors.count]
        return ZStack {
            backgroundColor
                .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Button {
                        feedback.impactOccurred()
                        isUserLogin = true
                    } label: {
                        Image("skip")
                    }
                }.padding(.horizontal, 16)
                Spacer()
                VStack {
                    Text(texts[currentTextIndex])
                        .modifier(BodyModifier())
                }
                .textAreaConteiner()
                .padding(.horizontal, 26)
                Spacer()
                Image("tapToContinue")
                    .padding(.bottom, 30)
            }
        }
        .onTapGesture {
            withAnimation {
                feedback.impactOccurred()
                currentTextIndex = (currentTextIndex + 1) % texts.count
                if backgroundColor == .brown {
                    isUserLogin = true
                }
            }
        }
    }
}

#Preview {
    OnboardingView()
}
