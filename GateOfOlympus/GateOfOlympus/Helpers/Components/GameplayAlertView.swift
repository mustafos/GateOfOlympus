//
//  GameplayAlertView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 21.05.2024.
//

import SwiftUI

struct GameplayAlertView: View {
    @State private var showAlert: Bool = true
    @State private var animateAlert: Bool = false
    var body: some View {
        if $showAlert.wrappedValue {
            ZStack {
                Color("ColorTransparentBlack").edgesIgnoringSafeArea(.all)
                
                // MODAL
                VStack(spacing: 0) {
                    // TITLE
                    Text("GAME OVER")
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color("ColorPink"))
                        .foregroundColor(Color.white)
                    
                    Spacer()
                    
                    // MESSAGE
                    VStack(alignment: .center, spacing: 16) {
                        Image("gfx-seven-reel")
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 72)
                        
                        Text("Bad luck! You lost all of the coins. \nLet's play again!")
                            .font(.system(.body, design: .rounded))
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.gray)
                            .layoutPriority(1)
                        
                        Button {
                            
                        } label: {
                            Text("New Game".uppercased())
                                .gradientButton()
                        }
                    }
                    
                    Spacer()
                }
                .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
                .opacity($animateAlert.wrappedValue ? 1 : 0)
                .offset(y: $animateAlert.wrappedValue ? 0 : -100)
                .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0), value: showAlert)
                .onAppear(perform: {
                    self.animateAlert = true
                })
            }
        }
    }
}

#Preview {
    GameplayAlertView()
}
