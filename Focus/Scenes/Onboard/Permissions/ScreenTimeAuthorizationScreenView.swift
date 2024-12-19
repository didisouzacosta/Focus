//
//  ScreenTimeAuthorizationScreenView.swift
//  Focus
//
//  Created by Adriano Souza Costa on 06/07/24.
//

import SwiftUI
import FamilyControls
import FocusCore

struct ScreenTimeAuthorizationScreenView: View {
    
    @Environment(PermissionsStore.self) private var permissionsStore
    
    let action: () -> Void
    
    var body: some View {
        AuthorizationRequestView(
            "Screen Time",
            message: "Focus request authorization it to see your activity data and limit the usage of apps.",
            image: "hourglass",
            isLoading: permissionsStore.awaiting
        ) {
            Task {
                do {
                    try await permissionsStore.requestScreenTimeAuthorization(for: .individual)
                    action()
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
}

#Preview {
    ScreenTimeAuthorizationScreenView {}
        .environment(PermissionsStore(.preview))
}
