//
//  ScaleModifier.swift
//  izza
//
//  Created by Codex on 10.09.2026.
//

import SwiftUI

private struct ScaleTargetBoundsKey: PreferenceKey {
    static let defaultValue: Anchor<CGRect>? = nil

    static func reduce(
        value: inout Anchor<CGRect>?,
        nextValue: () -> Anchor<CGRect>?
    ) {
        value = nextValue() ?? value
    }
}

private nonisolated struct ScaleMetrics: Equatable, Sendable {
    var sceneHeight: CGFloat = .zero
    var sceneGlobalMinY: CGFloat = .zero
    var destinationGlobalY: CGFloat = .zero
    var targetMidY: CGFloat = .zero

    func anchor(for factor: CGFloat) -> UnitPoint {
        guard sceneHeight > 0, factor != 1 else { return .center }

        let destinationY = destinationGlobalY - sceneGlobalMinY
        let anchorY = (factor * targetMidY - destinationY)
            / ((factor - 1) * sceneHeight)

        return UnitPoint(x: 0.5, y: anchorY)
    }
}

private struct ScaleModifier: ViewModifier {
    let factor: CGFloat
    let isActive: Bool

    @State private var metrics = ScaleMetrics()

    func body(content: Content) -> some View {
        ZStack {
            content
                .onGeometryChange(for: CGFloat.self) { proxy in
                    proxy.size.height
                } action: { newValue in
                    metrics.sceneHeight = newValue
                }
                .overlayPreferenceValue(ScaleTargetBoundsKey.self) { targetBounds in
                    GeometryReader { proxy in
                        let targetMidY = targetBounds.map { proxy[$0].midY }

                        Color.clear
                            .onChange(of: targetMidY, initial: true) { _, newValue in
                                guard let newValue else { return }
                                metrics.targetMidY = newValue
                            }
                    }
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
                }
                .scaleEffect(isActive ? factor : 1, anchor: metrics.anchor(for: factor))
        }
        .onGeometryChange(for: CGFloat.self) { proxy in
            proxy.frame(in: .global).minY
        } action: { newValue in
            metrics.sceneGlobalMinY = newValue
        }
        .background {
            Color.clear
                .onGeometryChange(for: CGFloat.self) { proxy in
                    proxy.frame(in: .global).midY
                } action: { newValue in
                    metrics.destinationGlobalY = newValue
                }
                .ignoresSafeArea()
        }
    }
}

extension View {
    func scaleTarget() -> some View {
        anchorPreference(
            key: ScaleTargetBoundsKey.self,
            value: .bounds
        ) {
            $0
        }
    }

    func scale(_ factor: CGFloat, isActive: Bool = true) -> some View {
        modifier(ScaleModifier(factor: factor, isActive: isActive))
    }
}
