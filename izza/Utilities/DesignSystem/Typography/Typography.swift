//
//  Typography.swift
//  izza
//
//  Created by Oleh on 08.09.2026.
//

import CoreGraphics
import CoreText
import Foundation

enum Figtree {
    enum Weight: CaseIterable {
        case light
        case regular
        case medium
        case semibold
        case bold
        case extraBold
        case black

        var fontName: String {
            switch self {
            case .light:
                "Figtree-Light"
            case .regular:
                "Figtree-Regular"
            case .medium:
                "Figtree-Medium"
            case .semibold:
                "Figtree-SemiBold"
            case .bold:
                "Figtree-Bold"
            case .extraBold:
                "Figtree-ExtraBold"
            case .black:
                "Figtree-Black"
            }
        }
    }

    static func registerFontsIfNeeded() {
        _ = registeredFonts
    }

    private static let registeredFonts: Void = {
        for weight in Weight.allCases {
            guard let url = Bundle.main.url(
                forResource: weight.fontName,
                withExtension: "ttf"
            ) else {
                assertionFailure("Missing font resource: \(weight.fontName).ttf")
                continue
            }

            var error: Unmanaged<CFError>?
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            _ = error?.takeRetainedValue()
        }
    }()
}

enum Typography: CaseIterable {
    case h1
    case h2
    case h3
    case body
    case minimal

    var fontName: String {
        weight.fontName
    }

    var weight: Figtree.Weight {
        switch self {
        case .h1:
            .light
        case .h2:
            .semibold
        case .h3:
            .bold
        case .body, .minimal:
            .regular
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .h1:
            32
        case .h2:
            24
        case .h3:
            16
        case .body:
            12
        case .minimal:
            10
        }
    }

    var lineHeight: CGFloat? {
        switch self {
        case .h1:
            32
        case .h2:
            24
        case .h3:
            18
        case .body:
            nil
        case .minimal:
            12
        }
    }

    var letterSpacing: CGFloat {
        switch self {
        case .h1, .h2:
            fontSize * -0.02
        case .h3, .body, .minimal:
            0
        }
    }
}
