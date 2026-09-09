//
//  izzaApp.swift
//  izza
//
//  Created by Oleh on 08.09.2026.
//

import SwiftUI

struct MainContainer: View {
    @State private var isSplashVisible: Bool = true
    private let splashTransition = AnyTransition
        .scale(scale: 0.001, anchor: .center)
        .combined(with: .opacity)

    var body: some View {
        ZStack {
            if isSplashVisible {
                SplashView(
                    onCycleCompleted: {
                        true
                    },
                    onStopped: {
                        withAnimation(.easeOut(duration: 0.15)) {
                            isSplashVisible = false
                        }
                    }
                )
                .transition(splashTransition)
                .zIndex(1)
            }
            
            DetailsView()
        }
        .preferredColorScheme(.light)
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(3))
                isSplashVisible = true
            }
        }
    }
}

@main
struct izzaApp: App {
    var body: some Scene {
        WindowGroup {
            DetailsView()
                .preferredColorScheme(.light)
            //MainContainer()
        }
    }
}

#Preview {
    MainContainer()
}
