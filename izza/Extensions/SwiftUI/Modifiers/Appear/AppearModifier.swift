//
//  AppearModifier.swift
//  izza
//
//  Created by Oleh on 09.09.2026.
//

import SwiftUI

private struct EntrancePresentedKey: EnvironmentKey {
    static let defaultValue = true
}

extension EnvironmentValues {
    var entrancePresented: Bool {
        get { self[EntrancePresentedKey.self] }
        set { self[EntrancePresentedKey.self] = newValue }
    }
}

private struct AppearModifier: ViewModifier {
    @Environment(\.entrancePresented)
    private var isPresented: Bool
    
    let edge: Edge?
    let animation: Animation
    
    func body(content: Content) -> some View {
        let isPresented = self.isPresented
        return content
            .visualEffect { content, proxy in
                let offset = offset(isPresented: isPresented, size: proxy.size)

                return content.offset(
                    x: offset.width,
                    y: offset.height
                )
            }
            .opacity(isPresented ? 1 : 0)
            .allowsHitTesting(isPresented)
            .accessibilityHidden(!isPresented)
            .animation(animation, value: isPresented)
    }

    nonisolated private func offset(isPresented: Bool, size: CGSize) -> CGSize {
        guard !isPresented else { return .zero }

        return switch edge {
        case .leading:
            CGSize(width: -size.width, height: 0)
        case .trailing:
            CGSize(width: size.width, height: 0)
        case .top:
            CGSize(width: 0, height: -size.height)
        case .bottom:
            CGSize(width: 0, height: size.height)
        case .none:
            .zero
        }
    }
}

extension View {
    func appear(
        from edge: Edge? = nil,
        animation: Animation = .bouncy(duration: 0.5, extraBounce: 0.2)
    ) -> some View {
        modifier(
            AppearModifier(
                edge: edge,
                animation: animation
            )
        )
    }
}
