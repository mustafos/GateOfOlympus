//
//  ContentView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var manager = UserViewModel()
    var body: some View {
        if manager.isUserLogin {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
        } else {
            OnboardingView()
                .environmentObject(manager)
        }
    }
}

#Preview {
    ContentView()
}
