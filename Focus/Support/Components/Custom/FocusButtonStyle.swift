//
//  FocusButtonStyle.swift
//  Focus
//
//  Created by Adriano Souza Costa on 08/07/24.
//

import Foundation
import SwiftUI

struct FocusButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.label
                .font(.headline)
                .foregroundStyle(.patternTextButton)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 32)
        .background(.patternBlack)
        .clipShape(RoundedRectangle(cornerRadius: .infinity))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
        .opacity(configuration.isPressed ? 0.8 : 1)
    }
    
}

#Preview {
    VStack {
        Button(action: {}, label: {
            Text("Action")
        })
        .buttonStyle(FocusButtonStyle())
    }
}
