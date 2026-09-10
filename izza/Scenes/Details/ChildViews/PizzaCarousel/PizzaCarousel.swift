//
//  PizzaCarousel.swift
//  izza
//
//  Created by Oleh on 08.09.2026.
//

import SwiftUI

struct PizzaCarousel: View {
    let images: [ImageSource]
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
                    ForEach(images.indices, id: \.self) { index in
                        imageView(for: images[index])
                            .frame(width: itemDiameter, height: itemDiameter)
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
                                selection = index
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
            .animation(.bouncy(duration: 0.25), value: selection)
            .scrollClipDisabled()
            .coordinateSpace(name: "pizzaCarousel")
        }
        .animation(.bouncy(duration: 0.15, extraBounce: 0.2), value: size)
        .aspectRatio(designScreenWidth / Size.medium.rawValue, contentMode: .fit)
    }
}

// MARK: - Image view setup
extension PizzaCarousel {
    @ViewBuilder
    private func imageView(for source: ImageSource) -> some View {
        switch source {
        case .local(let image):
            image
                .resizable()
                .scaledToFit()

        case .url(let url):
            AsyncImage(
                url: url,
                transaction: Transaction(animation: .easeInOut(duration: 0.25))
            ) { phase in
                switch phase {
                case .empty:
                    Ellipse()
                        .fill(.secondary.opacity(0.5))
                        .shimmering()
                        .transition(.opacity)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .transition(.opacity)

                case .failure:
                    Ellipse()
                        .fill(.red.opacity(0.5))
                        .overlay {
                            Image(systemName: "exclamationmark.octagon")
                                .foregroundStyle(.red.opacity(0.5))
                                .font(.system(size: 40))
                        }
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}

// MARK: - Data Models
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

extension PizzaCarousel {
    enum ImageSource {
        case local(Image)
        case url(URL)
    }
}

// MARK: - Preview
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
                images: [
                    .local(Image(.pizzaClassic)),
                    .local(Image(.pizzaPink)),
                    .local(Image(.pizzaGreen))
                ],
                selection: $selection,
                size: selectedSize
            )
        }
    }
}

#Preview {
    PizzaCarouselPreview()
}
