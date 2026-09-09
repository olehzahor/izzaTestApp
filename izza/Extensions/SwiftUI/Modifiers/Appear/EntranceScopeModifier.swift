//
//  EntranceScope.swift
//  izza
//
//  Created by Oleh on 09.09.2026.
//

import SwiftUI

private struct EntranceScopeModifier: ViewModifier {
    @State private var isPresented = false

    func body(content: Content) -> some View {
        content
            .environment(
                \.entrancePresented,
                isPresented
            )
            .onAppear {
                isPresented = true
            }
    }
}

extension View {
    func entranceScope(isPresented: Bool) -> some View {
        environment(
            \.entrancePresented,
            isPresented
        )
    }

    func entranceScope() -> some View {
        modifier(EntranceScopeModifier())
    }
}
