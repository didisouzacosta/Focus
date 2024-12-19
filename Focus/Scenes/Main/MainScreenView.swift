//
//  MainScreenView.swift
//  Focus
//
//  Created by Adriano Souza Costa on 08/07/24.
//

import SwiftUI
import FocusCore
import WindowKit

struct MainScreenView: View {
    
    // MARK: - Private Variables
    
    @Environment(PermissionsStore.self) private var permissionsStore
    @Environment(\.windowScene) private var windowScene
    
    @State private var isPresentOnboard = false
    @State private var selection = 0
    
    private let settings = Settings.shared
    
    // MARK: - Life Cicle
    
    var body: some View {
        Group {
            if permissionsStore.screenTimeIsAllowed {
                TabView(selection: $selection) {
                    MetricsScreenView()
                        .tabItem {
                            Label("Metrics", systemImage: "hourglass")
                        }
                        .tag(0)
                    
                    PlansListScreenView()
                        .tabItem {
                            Label("Plans", systemImage: "lock.shield")
                        }
                        .tag(1)
                    
                    SettingsScreenView()
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                        .tag(2)
                }
            } else {
                ScreenTimeAuthorizationScreenView {}
            }
        }
        .fullScreenCover(isPresented: $isPresentOnboard) {
            OnboardScreenView {
                isPresentOnboard.toggle()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    windowScene?.dimissSyncWindow()
                }
            }
        }
        .onAppear {
            isPresentOnboard = !settings.onboardIsCompleted
        }
    }
    
}

#Preview {
    MainScreenView()
        .environment(FocusPlanStore(.preview, setingsStore: .preview))
        .environment(PermissionsStore(.preview))
}
