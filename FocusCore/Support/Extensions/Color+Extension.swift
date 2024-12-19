//
//  Color+Extension.swift
//  Focus
//
//  Created by Adriano Souza Costa on 23/08/24.
//

import SwiftUI

public extension Color {
    
    static func random(randomOpacity: Bool = false) -> Color {
        .init(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            opacity: randomOpacity ? .random(in: 0...1) : 1
        )
    }
    
}
