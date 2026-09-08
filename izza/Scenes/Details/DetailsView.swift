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

    private let pizzaColors: [Color] = [.green, .orange, .red, .yellow]
    private let sizes = ["S", "M", "L"]
    
    private let designScreenWidth = 375.0
    private let designEllipseDiameter = 607.0
    
    private let buttonSize = 48.0

    private func heroSection() -> some View {
        VStack(spacing: 0) {
            header()
            
            PizzaCarousel(
                colors: pizzaColors,
                selection: $selectedPizza,
                size: .fromString(selectedSize)
            )
            .padding(.top, 54)
            .padding(.bottom, 41)
            
            sizePicker()
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

    private func header() -> some View {
        HStack {
            roundButton(systemName: "arrow.left") {}

            Spacer()

            VStack(spacing: 0) {
                Text("Pizzas")
                    .font(.figtree(size: 10, weight: .regular))
                    .foregroundStyle(.text)
                    .lineLimit(1)

                Text("Pepperoni Blast")
                    .font(.figtree(size: 24, weight: .semibold))
                    .foregroundStyle(.active)
                    .lineLimit(1)
            }

            Spacer()

            roundButton(
                systemName: isFavorite ? "heart.fill" : "heart",
                foregroundColor: isFavorite ? .red : .primary
            ) {
                isFavorite.toggle()
            }
        }
        .padding(.horizontal, 24)
    }

    private func sizePicker() -> some View {
        HStack(alignment: .bottom, spacing: buttonSize) {
            ForEach(sizes, id: \.self) { size in
                VStack(spacing: -15) {
                    if size == "M" {
                        Image(.banana)
                    }

                    sizeButton(
                        label: size,
                        isSelected: selectedSize == size
                    ) {
                        selectedSize = size
                    }
                }
                .offset(y: size == "M" ? 0 : -buttonSize * 0.5)
            }
        }
    }

    private func sizeButton(
        label: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(label)
                .font(.figtree(size: 18, weight: .semibold))
                .foregroundStyle(isSelected ? .white : .primary)
                .frame(width: buttonSize, height: buttonSize)
                .background(isSelected ? Color.black : Color.white)
                .clipShape(Circle())
                .overlay {
                    if isSelected {
                        Circle()
                            .stroke(.white, lineWidth: 2)
                            .frame(
                                width: buttonSize + 2,
                                height: buttonSize + 2
                            )
                    }
                }
                .shadow(color: .black.opacity(0.12), radius: 5, y: 3)
        }
    }

    private func descriptionSection() -> some View {
        Text("The combination of perfectly melted mozzarella cheese, tangy tomato sauce, and a crispy yet chewy crust creates a harmonious balance that leaves you wanting more.")
            .font(.figtree(size: 14))
            .lineSpacing(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 40)
    }

    private func counter() -> some View {
        return HStack(spacing: 8) {
            roundButton(systemName: "minus") {
                quantity = max(1, quantity - 1)
            }
                        
            Text("\(quantity)")
                .font(.figtree(size: 24, weight: .extraBold))
                .fixedSize(horizontal: true, vertical: false)
                .frame(minWidth: 32)
                .background(.highlight)

            roundButton(systemName: "plus") {
                quantity += 1
            }
        }
        .foregroundStyle(.primary)
        .background(.highlight)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.12), radius: 6, y: 3)
    }
    
    private func orderBar() -> some View {
        HStack {
            counter()
            
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

    private func roundButton(
        systemName: String,
        foregroundColor: Color = .primary,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(foregroundColor)
                .frame(width: 48, height: 48)
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.12), radius: 6, y: 3)
        }
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            heroSection()
            descriptionSection()
                .padding(.top, 21)
            Spacer(minLength: 16)
            orderBar()
        }
        .padding(.bottom, 22)
        .background(Color.white)
    }
}

#Preview {
    DetailsView()
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
