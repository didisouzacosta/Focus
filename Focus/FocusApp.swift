//
//  FocusApp.swift
//  Focus
//
//  Created by Adriano Souza Costa on 04/07/24.
//

import SwiftUI
import WindowKit
import FocusCore

@main
struct FocusApp: App {
    
    @Environment(\.windowScene) var windowScene
    
    private let focusPlanStore = FocusPlanStore(.shared, setingsStore: .shared)
    private let permissionsStore = PermissionsStore(.shared)
    private let settings = Settings.shared
    
    var body: some Scene {
        WindowGroup {
            MainScreenView()
                .windowOverlay {
                    SyncScreenView()
                        .onAppear {
                            if settings.onboardIsCompleted {
                                windowScene?.dimissSyncWindow()
                            }
                        }
                }
        }
        .environment(focusPlanStore)
        .environment(permissionsStore)
    }
    
}
