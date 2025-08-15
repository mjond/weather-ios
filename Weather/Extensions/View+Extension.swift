//
//  View+Extension.swift
//  Weather
//
//  Created by Mark Davis on 10/26/24.
//

import SwiftUI

struct Shimmer: ViewModifier {
    @State private var isAnimating = false

    func body(content: Content) -> some View {
        content
            .mask(LinearGradient(gradient: Gradient(colors: [Color.clear, Color.white, Color.clear]), startPoint: .leading, endPoint: .trailing)
                .offset(x: isAnimating ? UIScreen.main.bounds.width : -UIScreen.main.bounds.width)
                .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: isAnimating)
            )
            .onAppear {
                DispatchQueue.main.async {
                    withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        self.isAnimating = true
                    }
                }
            }
    }
}

public extension View {
    func shimmer() -> some View {
        modifier(Shimmer())
    }
}
