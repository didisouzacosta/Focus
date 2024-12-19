//
//  DotsView.swift
//  Focus
//
//  Created by Adriano Souza Costa on 24/07/24.
//

import SwiftUI

struct DotsView: View {
    
    @State private var current = 0
    
    private let animated: Bool
    private let lenght: Int
    private let spacing: CGFloat
    private let size: CGFloat
    
    init(
        animated: Bool = true,
        lenght: Int = 3,
        spacing: CGFloat = 4,
        size: CGFloat = 4
    ) {
        self.animated = animated
        self.lenght = lenght
        self.spacing = spacing
        self.size = size
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach((0..<lenght), id: \.self) { index in
                Circle()
                    .frame(width: size, height: size)
                    .opacity(animated ? current == index ? 0.1 : 1 : 1)
            }
        }
        .animation(.easeOut, value: current)
        .onAppear {
            guard animated else { return }
            Timer.scheduledTimer(withTimeInterval: 0.26, repeats: true) { _ in
                current = (current + 1) % lenght
            }
        }
    }
}

#Preview {
    DotsView(animated: true)
        .foregroundStyle(.patternActive)
}
