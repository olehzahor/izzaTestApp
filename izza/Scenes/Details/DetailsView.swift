//
//  DetailsView.swift
//  izza
//
//  Created by Oleh on 08.09.2026.
//

import SwiftUI

struct DetailsView: View {
    @State private var viewModel: DetailsViewModel
    
    @State private var isPizzaZoomed = false
    
    private let designScreenWidth = 375.0
    private let designEllipseDiameter = 607.0
    
    @State private var sceneHeight: CGFloat = .zero
    @State private var pizzaMidY: CGFloat = .zero
    @State private var pizzaMidYGloabal: CGFloat = .zero

    @State private var screenCenterY: CGFloat = .zero
    @State private var safeAreaTop: CGFloat = .zero
    @State private var safeAreaBottom: CGFloat = .zero

    private var scaleAnchor: CGFloat {
        guard sceneHeight > 0 else { return 0.5 }
        
        print("sceneHeight: \(sceneHeight)")
        print("pizzaMidY: \(pizzaMidY)")
        print("pizzaMidYGloabal: \(pizzaMidYGloabal)")
        print("screenCenterY: \(screenCenterY)")
        print("safeAreaTop: \(safeAreaTop)")
        print("safeAreaBottom: \(safeAreaBottom)")

        let zoomScale: CGFloat = 2.96
        let screenHeight: CGFloat = 874

        let screenCenter = screenHeight / 2
        let pizzaTravel = screenCenter - pizzaMidYGloabal
        let anchorToPizza = pizzaTravel / (zoomScale - 1)

        let anchorY = pizzaMidY - anchorToPizza

        return anchorY / sceneHeight
    }

    private let buttonSize = 48.0

    @State private var isPizzaExpanded = false

    private func sizePicker() -> some View {
        HStack(alignment: .bottom, spacing: 26) {
            ForEach(PizzaSize.allCases, id: \.self) { size in
                VStack(spacing: -15) {
                    if size == .medium {
                        Image(.banana)
                    }

                    RoundButton(
                        text: size.rawValue,
                        isSelected: viewModel.selectedSize == size
                    ) {
                        viewModel.selectedSize = size
                    }
                    .buttonStyle(StaticButtonStyle())
                }
                .offset(y: size == .medium ? 0 : -16)
            }
        }
    }

    private func heroSection() -> some View {
        VStack(spacing: 0) {
            NavigationHeader(
                category: "Pizzas",
                title: viewModel.selectedPizza.name,
                trailingSystemName: viewModel.isFavorite ? "heart.fill" : "heart",
                trailingForegroundColor: viewModel.isFavorite ? .red : .active,
                onBack: {},
                onTrailingButtonTap: { viewModel.isFavorite.toggle() }
            )
            
            PizzaCarousel(
                images: [.local(.init(.pizzaPink))],// viewModel.pizzaImageURLs.map { .url($0) },
                selection:
                    Binding(
                        get: { viewModel.selectedPizzaIndex },
                        set: { newValue in
                            guard let newValue,
                                  newValue != viewModel.selectedPizzaIndex else {
                                return
                            }
                            
                            withAnimation(.snappy) {
                                viewModel.selectedPizzaIndex = newValue
                            }
                        }
                    ),
                size: PizzaCarousel.Size(viewModel.selectedSize)
            )
            .onGeometryChange(for: CGFloat.self, of: { proxy in
                proxy.frame(in: .named("details")).midY
            }, action: { newValue in
                guard !isPizzaZoomed else { return }

                self.pizzaMidY = newValue
            })
            .onGeometryChange(for: CGFloat.self, of: { proxy in
                proxy.frame(in: .global).midY
            }, action: { newValue in
                guard !isPizzaZoomed else { return }

                self.pizzaMidYGloabal = newValue
            })

            //.scaleTarget()
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
        Text(viewModel.selectedPizza.description)
            .font(.figtree(size: 14))
            .lineSpacing(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 40)
    }

    private func orderBar() -> some View {
        HStack {
            StepperView(value: $viewModel.quantity)
            
            Spacer()

            Text("$\(viewModel.price, specifier: "%.2f")")
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
        .coordinateSpace(name: "details")
        .onGeometryChange(for: CGFloat.self, of: { proxy in
            proxy.frame(in: .named("details")).midY
        }, action: { newValue in
            guard !isPizzaZoomed else { return }

            self.screenCenterY = newValue
        })
        .onGeometryChange(for: CGFloat.self, of: { proxy in
            proxy.frame(in: .global).height
        }, action: { newValue in
            guard !isPizzaZoomed else { return }

            self.sceneHeight = newValue
        })
        .onGeometryChange(for: CGFloat.self, of: { proxy in
            proxy.safeAreaInsets.top
        }, action: { newValue in
            guard !isPizzaZoomed else { return }

            self.safeAreaTop = newValue
        })
        .onGeometryChange(for: CGFloat.self, of: { proxy in
            proxy.safeAreaInsets.bottom
        }, action: { newValue in
            guard !isPizzaZoomed else { return }
            self.safeAreaBottom = newValue
        })
        .coordinateSpace(name: "details")


        .scaleEffect(isPizzaZoomed ? 2.96 : 1, anchor: .init(x: 0.5, y: scaleAnchor))
        //.scale(isPizzaZoomed ? 3 : 1)
        .entranceScope()
    }
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Utilities
private struct StaticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

extension PizzaCarousel.Size {
    init(_ pizzaSize: PizzaSize) {
        switch pizzaSize {
        case .small:
            self = .small
        case .medium:
            self = .medium
        case .large:
            self = .large
        }
    }
}

// MARK: - Preview
#Preview {
    DetailsView(viewModel: DetailsViewModel(repo: MockDetailsRepository()))
}
