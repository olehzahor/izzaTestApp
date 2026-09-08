//
//  StepperView.swift
//  izza
//
//  Created by Oleh on 08.09.2026.
//

import SwiftUI

struct StepperView: View {
    @Binding private var value: Int

    private let minimumValue: Int

    init(value: Binding<Int>, minimumValue: Int = 1) {
        _value = value
        self.minimumValue = minimumValue
    }

    var body: some View {
        HStack(spacing: 8) {
            RoundButton(systemName: "minus") {
                value = max(minimumValue, value - 1)
            }

            Text("\(value)")
                .font(.figtree(size: 24, weight: .extraBold))
                .fixedSize(horizontal: true, vertical: false)
                .frame(minWidth: 32)
                .background(.highlight)

            RoundButton(systemName: "plus") {
                value += 1
            }
        }
        .foregroundStyle(.primary)
        .background(.highlight)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.12), radius: 6, y: 3)
    }
}
