//
//  NavBarComponent.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct NavBarComponent: View {
    private let feedback = UIImpactFeedbackGenerator(style: .soft)
    var title: String
    var leftIcon: String
    var rightIcon: String
    var dismissLeftAction: () -> Void
    var dismissRightAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.navigation
            Text(title)
            
            HStack {
                Button {
                    withAnimation {
                        feedback.impactOccurred()
                        dismissLeftAction()
                    }
                } label: {
                    Image(leftIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 36)
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        feedback.impactOccurred()
                        dismissRightAction()
                    }
                } label: {
                    Image(rightIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 36)
                }
            }
        }
        .padding(20)
        .frame(height: 100)
    }
}

#Preview {
    NavBarComponent(title: "Header", leftIcon: "back", rightIcon: "plus") {
        print("Left")
    } dismissRightAction: {
        print("Right")
    }
}
