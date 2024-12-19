//
//  WelcomeScreenView.swift
//  Focus
//
//  Created by Adriano Souza Costa on 13/08/24.
//

import SwiftUI

struct WelcomeScreenView: View {
    
    @State private var angleAnimation: Double = 0
    
    let action: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 32) {
                Circle()
                    .glow(fill: AngularGradient(
                        gradient: .pattern,
                        center: .center,
                        angle: .degrees(angleAnimation)
                    ), lineWidth: 6)
                    .frame(width: 80, height: 80)
                
                VStack(spacing: -4) {
                    Text("Less phone.")
                    Text("More **real life**.")
                    Text("More **focus**.")
                        .foregroundStyle(.patternActive)
                }
                .font(.title)
                .foregroundStyle(.patternBlack)
            }
            .animation(.linear(duration: 4).repeatForever(autoreverses: false), value: angleAnimation)
            
            Spacer()
            
            Button("Start") {
                action()
            }
            .buttonStyle(FocusButtonStyle())
        }
        .safeAreaPadding()
        .onAppear {
            angleAnimation = 360
        }
    }
}

#Preview {
    WelcomeScreenView() {}
}
