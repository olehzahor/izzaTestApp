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
    var screenFrame: CGRect = .zero
    var targetMidY: CGFloat = .zero

    func anchor(for factor: CGFloat) -> UnitPoint {
        guard sceneHeight > 0, factor != 1 else { return .center }

        let destinationY = screenFrame.midY - sceneGlobalMinY
        let anchorY = (factor * targetMidY - destinationY)
            / ((factor - 1) * sceneHeight)

        return UnitPoint(x: 0.5, y: anchorY)
    }
}

private enum ScaleAmount {
    case factor(CGFloat)
    case screenHeight(CGFloat, targetHeight: CGFloat)

    func factor(screenHeight: CGFloat) -> CGFloat {
        switch self {
        case .factor(let factor):
            return factor
        case .screenHeight(let fraction, let targetHeight):
            guard screenHeight > 0, targetHeight > 0, fraction > 0 else { return 1 }
            return screenHeight * fraction / targetHeight
        }
    }
}

private struct ScaleModifier: ViewModifier {
    let amount: ScaleAmount
    let isActive: Bool

    @State private var metrics = ScaleMetrics()

    func body(content: Content) -> some View {
        let factor = amount.factor(screenHeight: metrics.screenFrame.height)

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
                .onGeometryChange(for: CGRect.self) { proxy in
                    proxy.frame(in: .global)
                } action: { newValue in
                    metrics.screenFrame = newValue
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
        modifier(ScaleModifier(amount: .factor(factor), isActive: isActive))
    }

    func scale(
        screenHeight fraction: CGFloat,
        targetHeight: CGFloat,
        isActive: Bool = true
    ) -> some View {
        modifier(ScaleModifier(
            amount: .screenHeight(fraction, targetHeight: targetHeight),
            isActive: isActive
        ))
    }
}
