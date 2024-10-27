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
                .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false))
                .offset(x: isAnimating ? UIScreen.main.bounds.width : -UIScreen.main.bounds.width)
            )
            .onAppear {
                DispatchQueue.main.async {
                    withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
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
