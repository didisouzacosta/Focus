//
//  NotificationsAuthorizationScreenView.swift
//  Focus
//
//  Created by Adriano Souza Costa on 06/07/24.
//

import SwiftUI
import FamilyControls
import FocusCore

struct NotificationsAuthorizationScreenView: View {
    
    @Environment(PermissionsStore.self) private var permissionsStore
    
    let action: () -> Void
    
    var body: some View {
        AuthorizationRequestView(
            "Push Notification",
            message: "Focus request authorization to send notifications personalized for you.",
            image: "app.badge",
            isLoading: permissionsStore.awaiting,
            skipAction: action
        ) {
            Task { @MainActor in
                do {
                    try await permissionsStore.requestNotificationAuthorization()
                    action()
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    NotificationsAuthorizationScreenView {}
        .environment(PermissionsStore(.preview))
}
