//
//  NavigationHeader.swift
//  izza
//
//  Created by Oleh on 08.09.2026.
//

import SwiftUI

struct NavigationHeader: View {
    let category: String
    let title: String
    let trailingSystemName: String
    let trailingForegroundColor: Color
    let onBack: () -> Void
    let onTrailingButtonTap: () -> Void

    var body: some View {
        HStack {
            RoundButton(systemName: "arrow.left", action: onBack)
                .appear(from: .leading)
            
            Spacer()

            VStack(spacing: 0) {
                Text(category)
                    .font(.figtree(size: 10, weight: .regular))
                    .foregroundStyle(.text)
                    .lineLimit(1)
                
                Text(title)
                    .font(.figtree(size: 24, weight: .semibold))
                    .foregroundStyle(.active)
                    .lineLimit(1)
            }
            .appear(from: .top)

            Spacer()
            
            RoundButton(
                systemName: trailingSystemName,
                foregroundColor: trailingForegroundColor,
                action: onTrailingButtonTap
            )
            .appear(from: .trailing)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    @Previewable @State var isPresented = false
    
    Toggle(isOn: $isPresented) {
        Text("isPresented")
    }
    .frame(width: 200)
    .padding(.bottom, 100)
    
    NavigationHeader(
        category: "Pizzas",
        title: "Pepperoni Blast",
        trailingSystemName: "heart",
        trailingForegroundColor: .active,
        onBack: {},
        onTrailingButtonTap: {}
    )
    .entranceScope(isPresented: isPresented)
    .onAppear {
        isPresented = true
    }
}
