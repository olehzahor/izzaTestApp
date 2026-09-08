//
//  RoundButton.swift
//  izza
//
//  Created by Oleh on 08.09.2026.
//

import SwiftUI

struct RoundButton: View {
    private enum Content {
        case text(String)
        case systemImage(String)
        case image(Image)
    }

    private let content: Content
    private let isSelected: Bool
    private let foregroundColor: Color
    private let action: () -> Void
    
    @ViewBuilder
    private var contentView: some View {
        switch content {
        case let .text(text):
            Text(text)
                .font(.figtree(size: 18, weight: .semibold))
        case let .systemImage(systemName):
            Image(systemName: systemName)
                .font(.system(size: 20, weight: .medium))
        case let .image(image):
            image
        }
    }

    var body: some View {
        Button(action: action) {
            contentView
                .foregroundStyle(isSelected ? .white : foregroundColor)
                .frame(width: 48, height: 48)
                .background(isSelected ? Color.black : Color.white)
                .clipShape(Circle())
                .overlay {
                    if isSelected {
                        Circle()
                            .stroke(.white, lineWidth: 2)
                            .frame(width: 50, height: 50)
                    }
                }
                .shadow(color: .black.opacity(0.15), radius: 8, y: 2)
        }
    }
    
    init(
        text: String,
        isSelected: Bool = false,
        foregroundColor: Color = .active,
        action: @escaping () -> Void
    ) {
        content = .text(text)
        self.isSelected = isSelected
        self.foregroundColor = foregroundColor
        self.action = action
    }

    init(
        systemName: String,
        isSelected: Bool = false,
        foregroundColor: Color = .primary,
        action: @escaping () -> Void
    ) {
        content = .systemImage(systemName)
        self.isSelected = isSelected
        self.foregroundColor = foregroundColor
        self.action = action
    }

    init(
        image: Image,
        isSelected: Bool = false,
        foregroundColor: Color = .primary,
        action: @escaping () -> Void
    ) {
        content = .image(image)
        self.isSelected = isSelected
        self.foregroundColor = foregroundColor
        self.action = action
    }
}
