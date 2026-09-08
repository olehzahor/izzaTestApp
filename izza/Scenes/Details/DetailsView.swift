//
//  DetailsView.swift
//  izza
//
//  Created by Oleh on 08.09.2026.
//

import SwiftUI

struct DetailsView: View {
    @State private var selectedPizza: Int? = 1
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

            VStack(spacing: 4) {
                Text("Pizzas")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Text("Pepperoni Blast")
                    .font(.title2.weight(.bold))
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
                        scaleHint()
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
                .font(.headline)
                .foregroundStyle(isSelected ? .white : .primary)
                .frame(width: buttonSize, height: buttonSize)
                .background(isSelected ? Color.black : Color.white)
                .clipShape(Circle())
                .overlay {
                    if isSelected {
                        Circle()
                            .strokeBorder(.white, lineWidth: 2)
                    }
                }
                .shadow(color: .black.opacity(0.12), radius: 5, y: 3)
        }
    }

    private func scaleHint() -> some View {
        Image(.banana)
    }

    private func descriptionSection() -> some View {
        Text("The combination of perfectly melted mozzarella cheese, tangy tomato sauce, and a crispy yet chewy crust creates a harmonious balance that leaves you wanting more.")
            .font(.body)
            .lineSpacing(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 40)
            .padding(.top, 36)
    }

    private func orderBar() -> some View {
        HStack(spacing: 14) {
            HStack(spacing: 18) {
                Button {
                    quantity = max(1, quantity - 1)
                } label: {
                    Image(systemName: "minus")
                        .frame(width: 44, height: 44)
                }

                Text("\(quantity)")
                    .font(.title3.bold())
                    .frame(minWidth: 20)

                Button {
                    quantity += 1
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 44, height: 44)
                }
            }
            .foregroundStyle(.primary)
            .background(.white)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.12), radius: 6, y: 3)

            Text("$17.99")
                .font(.title3.bold())

            Button("Add") {}
                .font(.title3.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 22)
                .frame(height: 52)
                .background(.cyan)
                .clipShape(Capsule())
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(.white)
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
            Spacer(minLength: 16)
        }
        .background(Color.white)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            orderBar()
        }
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
