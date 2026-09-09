//
//  izzaApp.swift
//  izza
//
//  Created by Oleh on 08.09.2026.
//

import SwiftUI

private struct MainContainer: View {
    private let detailsRepo: DetailsRepositoryProtocol

    @State private var isDataReceived: Bool = false
    @State private var error: Error? = nil
    
    @State private var isSplashVisible: Bool = true
    
    private let splashTransition = AnyTransition
        .scale(scale: 0.001, anchor: .center)
        .combined(with: .opacity)

    var body: some View {
        ZStack {
            if isSplashVisible, error == nil {
                SplashView(
                    onCycleCompleted: {
                        isDataReceived
                    },
                    onStopped: {
                        withAnimation(.easeOut(duration: 0.25)) {
                            isSplashVisible = false
                        }
                    }
                )
                .transition(splashTransition)
                .zIndex(1)
            } else if let error {
                ContentUnavailableView(
                    error.localizedDescription,
                    systemImage: "exclamationmark.octagon"
                )
            } else {
                DetailsView(viewModel: DetailsViewModel(repo: detailsRepo))
            }
        }
        .task {
            do {
                try await detailsRepo.fetchData()
                isDataReceived = true
            } catch {
                self.error = error
            }
        }
    }
    
    init(detailsRepo: DetailsRepositoryProtocol) {
        self.detailsRepo = detailsRepo
    }
}

@main
struct izzaApp: App {
    private let networkClient = NetworkClient()
    
    var body: some Scene {
        WindowGroup {
            MainContainer(detailsRepo: DetailsRepository(network: networkClient))
                .preferredColorScheme(.light)
        }
    }
}

// MARK: - Preview

#Preview {
    MainContainer(detailsRepo: MockDetailsRepository())
}
