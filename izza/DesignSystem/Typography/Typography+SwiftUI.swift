//
//  Typography+SwiftUI.swift
//  izza
//
//  Created by Oleh on 08.09.2026.
//

import SwiftUI

extension Font {
    static func figtree(
        size: CGFloat,
        weight: Figtree.Weight = .regular
    ) -> Font {
        Figtree.registerFontsIfNeeded()
        return .custom(weight.fontName, fixedSize: size)
    }

    static func typography(_ style: Typography) -> Font {
        .figtree(size: style.fontSize, weight: style.weight)
    }
}

extension View {
    func figtree(
        size: CGFloat,
        weight: Figtree.Weight = .regular
    ) -> some View {
        font(.figtree(size: size, weight: weight))
    }

    func typography(_ style: Typography) -> some View {
        modifier(TypographyModifier(style: style))
    }
}

private struct TypographyModifier: ViewModifier {
    let style: Typography

    func body(content: Content) -> some View {
        content
            .font(.typography(style))
            .tracking(style.letterSpacing)
            .lineSpacing(lineSpacing)
    }

    private var lineSpacing: CGFloat {
        guard let lineHeight = style.lineHeight else {
            return 0
        }

        return lineHeight - style.fontSize
    }
}
