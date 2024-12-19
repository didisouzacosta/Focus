//
//  AuthorizationRequestView.swift
//  Focus
//
//  Created by Adriano Souza Costa on 12/08/24.
//

import SwiftUI
import FamilyControls
import FocusCore

struct AuthorizationRequestView: View {
    
    // MARK: - Public Variables
    
    var title: String
    var message: String
    var image: String
    var isLoading: Bool
    var skipAction: (() -> Void)?
    var action: () -> Void
    
    // MARK: - Private Variables
    
    @State private var angleAnimation: Double = 0
    
    // MARK: - Life Cicle
    
    init(
        _ title: String,
        message: String,
        image: String,
        isLoading: Bool,
        skipAction: (() -> Void)? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.image = image
        self.isLoading = isLoading
        self.skipAction = skipAction
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 16) {
                AngularGradient(
                    gradient: .pattern,
                    center: .center,
                    angle: .degrees(angleAnimation)
                )
                .frame(width: 100, height: 100)
                .mask {
                    Image(systemName: image)
                        .font(.system(size: 80))
                }
                
                Text(title)
                    .bold()
                    .font(.title)
                
                Text(message)
                    .font(.body)
            }
            .multilineTextAlignment(.center)
            .foregroundStyle(.patternBlack)
            .animation(
                .linear(duration: 4).repeatForever(autoreverses: false),
                value: angleAnimation
            )
            
            if isLoading {
                ProgressView()
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                Button("Request Authorization") {
                    requestAuthorization()
                }.buttonStyle(FocusButtonStyle())
                
                if let skipAction {
                    Button("Skip") {
                        skipAction()
                    }
                    .disabled(isLoading)
                }
            }
        }
        .safeAreaPadding()
        .animation(.easeIn, value: isLoading)
        .onAppear {
            angleAnimation = 360
        }
    }
    
    // MARK: - Private Methods
    
    private func requestAuthorization() {
        action()
    }
}

#Preview {
    AuthorizationRequestView(
        "Authorization",
        message: "Authorization message",
        image: "circle",
        isLoading: false
    ) {}
}
