//
//  OnboardingView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI
import CoreData

struct OnboardingView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.accentColor
                    .ignoresSafeArea()
                Text("Welcome to the\nHeartBeat: Monitor, Analyze, Improve!")
                    .titleTextGen(size: 24)
                    .textAreaConteiner()
                    .padding(.horizontal, padding)
                
                VStack(spacing: 0) {
                    Spacer()
                    Text("Want to use the app?")
                        .smallTextGen()
                    
                    HStack(spacing: 0) {
                        Text("Accept ")
                            .smallTextGen()
                        Link(destination: URL(string: "https://www.google.com")!) {
                            Text("Terms of use")
                                .smallTextGen(color: .rose)
                        }
                        Text(" and ")
                            .smallTextGen()
                        
                        Link(destination: URL(string: "https://www.google.com")!) {
                            Text("Privacy Policy")
                                .smallTextGen(color: .rose)
                        }
                    }
                    
                    NavigationLink {
                        WelcomeDetailsView().navigationBarBackButtonHidden()
                    } label: {
                        Text("Continue")
                            .customGenButton()
                    }.padding(.top, padding)
                }
                .padding(.horizontal, padding)
                .padding(.bottom, 22)
            }
        }.navigationViewStyle(.stack)
    }
}

#Preview {
    OnboardingView()
}
