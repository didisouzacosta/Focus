//
//  UIWindowScene+Extension.swift
//  Focus
//
//  Created by Adriano Souza Costa on 14/08/24.
//

import SwiftUI
import WindowKit

extension UIWindowScene {
    
    func dimissSyncWindow() {
        windows
            .filter { String(describing: type(of: $0)) != "UIWindow" }
            .forEach { window in
                UIView.animate(withDuration: 0.26) {
                    window.alpha = 0
                } completion: { completed in
                    window.windowScene = nil
                }
            }
    }
    
}
