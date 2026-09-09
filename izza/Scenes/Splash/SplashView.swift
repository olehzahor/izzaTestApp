//
//  SplashView.swift
//  izza
//
//  Created by Oleh on 08.09.2026.
//

import SwiftUI

struct SplashView: View {
    private let frames: [String]
    private let frameDuration: Duration

    @State private var currentFrame = 0
    
    private let onCycleCompleted: () -> Bool
    private let onStopped: () -> Void
    
    var body: some View {
        Image(frames[currentFrame])
            .resizable()
            .scaledToFit()
            .frame(width: 270, height: 270)
            .task {
                while !Task.isCancelled {
                    try? await Task.sleep(for: frameDuration)

                    if currentFrame == frames.indices.last,
                       onCycleCompleted() {
                        onStopped()
                        return
                    }

                    currentFrame = (currentFrame + 1) % frames.count
                }
            }
    }
    
    /// Creates an animated splash view that cycles through the provided image frames.
    ///
    /// - Parameters:
    ///   - frames: Non-empty array of image asset names displayed in order.
    ///   - frameDuration: Amount of time each frame remains visible.
    ///   - onCycleCompleted: Called after the last frame of every cycle has been
    ///     displayed. Return `true` to stop the animation or `false` to start the
    ///     next cycle.
    ///   - onStopped: Called after `onCycleCompleted` requests the animation to stop.
    ///     Use this callback to remove the splash view with a transition.
    init(frames: [String] = (1...8).map { "splash\($0)" },
         frameDuration: Duration = .milliseconds(40),
         onCycleCompleted: @escaping () -> Bool = { false },
         onStopped: @escaping () -> Void = {}) {
        self.frames = frames
        self.frameDuration = frameDuration
        self.onCycleCompleted = onCycleCompleted
        self.onStopped = onStopped
    }
}

#Preview {
    SplashView()
}
