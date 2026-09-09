//
//  DetailsView.swift
//  izza
//
//  Created by Oleh on 08.09.2026.
//

import SwiftUI

struct DetailsView: View {
    @State private var selectedPizza: Int? = 0
    @State private var selectedSize = "M"
    @State private var quantity = 1
    @State private var isFavorite = false
    @State private var isPizzaZoomed = false
    
    private let pizzaImages = [
        Image(.pizzaClassic),
        Image(.pizzaPink),
        Image(.pizzaGreen)
    ]
    private let sizes = ["S", "M", "L"]
    
    private let designScreenWidth = 375.0
    private let designEllipseDiameter = 607.0
    
    private let buttonSize = 48.0

    @State private var isPizzaExpanded = false

    private func sizePicker() -> some View {
        HStack(alignment: .bottom, spacing: 26) {
            ForEach(sizes, id: \.self) { size in
                VStack(spacing: -15) {
                    if size == "M" {
                        Image(.banana)
                    }

                    RoundButton(
                        text: size,
                        isSelected: selectedSize == size
                    ) {
                        selectedSize = size
                    }
                    .buttonStyle(StaticButtonStyle())
                }
                .offset(y: size == "M" ? 0 : -16)
            }
        }
    }

    private func heroSection() -> some View {
        VStack(spacing: 0) {
            NavigationHeader(
                category: "Pizzas",
                title: "Pepperoni Blast",
                trailingSystemName: isFavorite ? "heart.fill" : "heart",
                trailingForegroundColor: isFavorite ? .red : .active,
                onBack: {},
                onTrailingButtonTap: { isFavorite.toggle() }
            )
            
            PizzaCarousel(
                images: pizzaImages,
                selection: $selectedPizza,
                size: .fromString(selectedSize)
            )
            .overlay {
                Image(.zoom)
                    .opacity(isPizzaZoomed ? 0.01 : 1)
                    .foregroundStyle(.white)
                    .onTapGesture {
                        withAnimation(.bouncy(duration: 0.35)) {
                            isPizzaZoomed.toggle()
                        }
                    }
            }
            .padding(.top, 54)
            .padding(.bottom, 41)
            .appear(animation: .linear)
            
            sizePicker()
                .appear(from: .bottom)
        }
        .background {
            GeometryReader { proxy in
                let widthScale = proxy.size.width / designScreenWidth
                let diameter = designEllipseDiameter * widthScale
                                
                Ellipse()
                    .fill(Color.highlight)
                    .frame(width: diameter, height: diameter)
                    .position(
                        x: proxy.size.width / 2,
                        y: proxy.size.height
                        - diameter / 2
                        - buttonSize / 2
                    )
            }
        }
    }

    private func descriptionSection() -> some View {
        Text("The combination of perfectly melted mozzarella cheese, tangy tomato sauce, and a crispy yet chewy crust creates a harmonious balance that leaves you wanting more.")
            .font(.figtree(size: 14))
            .lineSpacing(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 40)
    }

    private func orderBar() -> some View {
        HStack {
            StepperView(value: $quantity)
            
            Spacer()

            Text("$17.99")
                .font(.figtree(size: 24, weight: .extraBold))
            
            Spacer()

            Button("Add") {}
                .font(.figtree(size: 24, weight: .extraBold))
                .foregroundStyle(.white)
                .padding(.horizontal, 22)
                .frame(height: 48)
                .background(.accent)
                .clipShape(Capsule())
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .frame(height: 48)
    }
    
    @State var isPresented: Bool = false

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            heroSection()
            
            descriptionSection()
                .padding(.top, 21)
                .appear(from: .bottom)

            Spacer(minLength: 16)

            orderBar()
                .appear(animation: .linear)
        }
        .padding(.bottom, 22)
        .background(Color.white)
        .scaleEffect(isPizzaZoomed ? 4.0 : 1, anchor: .init(x: 0.5, y: 0.25))
        .entranceScope()
    }
}

// MARK: - Utilities
private struct StaticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

extension PizzaCarousel.Size {
    static func fromString(_ string: String) -> Self {
        switch string {
        case "S":
            return .small
        case "L":
            return .large
        default:
            return .medium
        }
    }
}

// MARK: - Preview
#Preview {
    DetailsView()
}
