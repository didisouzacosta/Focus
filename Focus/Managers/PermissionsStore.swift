//
//  PermissionsStore.swift
//  Focus
//
//  Created by Adriano Souza Costa on 11/08/24.
//

import SwiftUI
import FamilyControls
import FocusCore

@Observable
final class PermissionsStore {
    
    // MARK: - Public Variables
    
    private(set) var awaiting = false
    private(set) var notificationsIsAllowed = false
    
    var screenTimeIsAllowed: Bool {
        sharedData.screenTimeIsAllowed
    }
    
    // MARK: - Private Variables
    
    private let notificationCenter = NotificationCenter.default
    private let userNotificationCenter = UNUserNotificationCenter.current()
    private let authorizationCenter = AuthorizationCenter.shared
    private let sharedData: SharedData
    
    // MARK: - Life Cicle
    
    init(_ sharedData: SharedData) {
        self.sharedData = sharedData
        checkPermissions()
    }
    
    // MARK: - Public Methods
    
    func requestScreenTimeAuthorization(for member: FamilyControlsMember) async throws {
        awaiting = true
        
        do {
            try await authorizationCenter.requestAuthorization(for: member)
            sharedData.familyControlsMember = member
            sharedData.screenTimeIsAllowed = true
            
            awaiting = false
        } catch {
            awaiting = false
            sharedData.screenTimeIsAllowed = false
            throw error
        }
    }
    
    func requestNotificationAuthorization() async throws {
        awaiting = true
        
        do {
            try await userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
            awaiting = false
            notificationsIsAllowed = true
        } catch {
            awaiting = false
            notificationsIsAllowed = false
            throw error
        }
    }
    
    func checkPermissions() {
        checkScreenTimeAuthorizationStatus()
        checkNotificationsAuthorizationStatus()
    }
    
    // MARK: - Private Methods
    
    private func setupObservers() {
        notificationCenter.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.checkPermissions()
        }
    }
    
    private func checkNotificationsAuthorizationStatus() {
        awaiting = true
        
        userNotificationCenter.getNotificationSettings { [weak self] permissions in
            self?.notificationsIsAllowed = switch permissions.authorizationStatus {
            case .authorized: true
            default: false
            }
            
            self?.awaiting = false
        }
    }
    
    private func checkScreenTimeAuthorizationStatus() {
        let isAuthorized = switch authorizationCenter.authorizationStatus {
        case .denied, .notDetermined: false
        case .approved: true
        default: false
        }
        
        guard
            !isAuthorized,
            let member = sharedData.familyControlsMember
        else {
            return
        }
          
        Task { @MainActor in
            do {
                try await requestScreenTimeAuthorization(for: member)
            } catch {
                print(error)
            }
        }
    }
    
}

