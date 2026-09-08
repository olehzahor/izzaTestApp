//
//  PizzaCarouselItem.swift
//  izza
//
//  Created by Oleh on 08.09.2026.
//

import SwiftUI

struct PizzaCarouselItem: View {
    let color: Color
    let diameter: CGFloat

    var body: some View {
        let scale = diameter / 244

        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.yellow.opacity(0.9), color],
                        center: .center,
                        startRadius: 24 * scale,
                        endRadius: 125 * scale
                    )
                )

            Image(systemName: "circle.hexagongrid.fill")
                .resizable()
                .scaledToFit()
                .padding(22 * scale)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.red.opacity(0.8), .brown.opacity(0.75))

            Image(systemName: "leaf.fill")
                .font(.system(size: 34 * scale, weight: .bold))
                .foregroundStyle(.green)
                .offset(x: 46 * scale, y: -50 * scale)

            Circle()
                .stroke(.white, lineWidth: 2 * scale)
                .frame(width: 26 * scale, height: 26 * scale)
        }
        .frame(width: diameter, height: diameter)
        .shadow(
            color: .black.opacity(0.22),
            radius: 4 * scale,
            y: 3 * scale
        )
    }
}

#Preview {
    PizzaCarouselItem(color: .orange, diameter: 244)
}
