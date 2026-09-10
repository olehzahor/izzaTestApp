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

private nonisolated struct ScaleContainerMetrics: Equatable, Sendable {
    var sceneHeight: CGFloat
    var safeAreaTop: CGFloat
    var safeAreaBottom: CGFloat
}

private nonisolated struct ScaleMetrics: Equatable, Sendable {
    var sceneHeight: CGFloat = .zero
    var safeAreaTop: CGFloat = .zero
    var safeAreaBottom: CGFloat = .zero
    var targetMidY: CGFloat = .zero

    func anchor(for factor: CGFloat) -> UnitPoint {
        guard sceneHeight > 0, factor != 1 else { return .center }

        let sceneTotalHeight = sceneHeight + safeAreaTop + safeAreaBottom
        let destinationMidY = sceneTotalHeight / 2 - safeAreaTop
        let anchorY = (factor * targetMidY - destinationMidY) / (factor - 1)

        return UnitPoint(x: 0.5, y: anchorY / sceneHeight)
    }
}

private struct ScaleModifier: ViewModifier {
    let factor: CGFloat

    @State private var metrics = ScaleMetrics()

    func body(content: Content) -> some View {
        content
            .onGeometryChange(for: ScaleContainerMetrics.self) { proxy in
                ScaleContainerMetrics(
                    sceneHeight: proxy.size.height,
                    safeAreaTop: proxy.safeAreaInsets.top,
                    safeAreaBottom: proxy.safeAreaInsets.bottom
                )
            } action: { _, newValue in
                guard factor == 1 else { return }

                metrics.sceneHeight = newValue.sceneHeight
                metrics.safeAreaTop = newValue.safeAreaTop
                metrics.safeAreaBottom = newValue.safeAreaBottom
            }
            .overlayPreferenceValue(ScaleTargetBoundsKey.self) { targetBounds in
                GeometryReader { proxy in
                    let targetMidY = targetBounds.map { proxy[$0].midY }

                    Color.clear
                        .onChange(of: targetMidY, initial: true) { _, newValue in
                            guard factor == 1, let newValue else { return }
                            metrics.targetMidY = newValue
                        }
                }
                .allowsHitTesting(false)
                .accessibilityHidden(true)
            }
            .scaleEffect(factor, anchor: metrics.anchor(for: factor))
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

    func scale(_ factor: CGFloat) -> some View {
        modifier(ScaleModifier(factor: factor))
    }
}
