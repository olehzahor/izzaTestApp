//
//  PizzaCarousel.swift
//  izza
//
//  Created by Oleh on 08.09.2026.
//

import SwiftUI

struct PizzaCarousel: View {
    let colors: [Color]
    @Binding var selection: Int?
    
    var size: Size
    
    private let designScreenWidth = 375.0
    private let designCarouselItemSize = Size.medium.rawValue
    private let designSmallPizzaSize = 80.0
    
    var body: some View {
        GeometryReader { proxy in
            // Some math to adjust designed geometry to any screen width
            let widthScale = proxy.size.width / designScreenWidth
            let itemDiameter = designCarouselItemSize * widthScale
            let selectedDiameter = size.rawValue * widthScale
            let smallDiameter = designSmallPizzaSize * widthScale
            let selectedScale = selectedDiameter / itemDiameter
            let minimumScale = smallDiameter / itemDiameter
            let itemSpacing = proxy.size.width / 2 - itemDiameter
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: itemSpacing) {
                    ForEach(colors.indices, id: \.self) { index in
                        PizzaCarouselItem(
                            color: colors[index],
                            diameter: itemDiameter
                        )
                        .frame(width: itemDiameter)
                        .visualEffect { content, geometry in
                            let distanceFromCenter = abs(
                                geometry.frame(in: .named("pizzaCarousel")).midX
                                - proxy.size.width / 2
                            )
                            let progress = min(
                                distanceFromCenter / (proxy.size.width / 2),
                                1
                            )
                            
                            return content
                                .scaleEffect(
                                    selectedScale
                                    - progress * (selectedScale - minimumScale)
                                )
                        }
                        .onTapGesture {
                            withAnimation(.bouncy(duration: 0.25)) {
                                selection = index
                            }
                        }
                        .id(index)
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(
                .horizontal,
                max((proxy.size.width - itemDiameter) / 2, 0),
                for: .scrollContent
            )
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $selection)
            .scrollClipDisabled()
            .coordinateSpace(name: "pizzaCarousel")
        }
        .animation(.bouncy(duration: 0.15, extraBounce: 0.2), value: size)
        .aspectRatio(designScreenWidth / Size.medium.rawValue, contentMode: .fit)
    }
}

extension PizzaCarousel {
    enum Size: Double, CaseIterable, Identifiable {
        var id: Double { self.rawValue }
        
        case small = 196.0
        case medium = 244.0
        case large = 274.0
        
        var title: String {
            switch self {
            case .small:
                "Small"
            case .medium:
                "Medium"
            case .large:
                "Large"
            }
        }
    }
}

private struct PizzaCarouselPreview: View {
    @State private var selection: Int? = 0
    @State private var selectedSize: PizzaCarousel.Size = .medium
    
    var body: some View {
        VStack {
            HStack {
                ForEach(PizzaCarousel.Size.allCases) { size in
                    Button(size.title) {
                        selectedSize = size
                    }
                }
            }
            
            PizzaCarousel(
                colors: [.green, .orange, .red],
                selection: $selection,
                size: selectedSize
            )
        }
    }
}

#Preview {
    PizzaCarouselPreview()
}
