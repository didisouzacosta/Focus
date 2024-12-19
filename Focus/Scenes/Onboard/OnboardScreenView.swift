//
//  WalkthroughScreenView.swift
//  Focus
//
//  Created by Adriano Souza Costa on 12/08/24.
//

import SwiftUI
import FocusCore

struct OnboardScreenView: View {
    
    // MARK: - Public Variables
    
    let action: () -> Void
    
    // MARK: - Private Variables
    
    @State private var currentStep = OnboardStep.welcome
    
    private let settings = Settings.shared
    
    // MARK: - Life Cicle
    
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        TabView(selection: $currentStep) {
            WelcomeScreenView {
                go(to: .notifications)
            }
            .simultaneousGesture(DragGesture())
            .tag(OnboardStep.welcome)
            
            NotificationsAuthorizationScreenView {
                go(to: .screenTime)
            }
            .simultaneousGesture(DragGesture())
            .tag(OnboardStep.notifications)
            
            ScreenTimeAuthorizationScreenView {
                finish()
            }
            .simultaneousGesture(DragGesture())
            .tag(OnboardStep.screenTime)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
    }
    
    // MARK: - Private Methods
    
    private func go(to step: OnboardStep) {
        withAnimation {
            currentStep = step
        }
    }
    
    private func finish() {
        settings.onboardIsCompleted = true
        action()
    }
    
}

extension OnboardScreenView {
    
    enum OnboardStep: Hashable {
        case welcome, notifications, screenTime
    }
    
}

#Preview {
    OnboardScreenView {}
        .environment(PermissionsStore(.preview))
}
