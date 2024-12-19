//
//  FormulateButtonField.swift
//  Formulate
//
//  Created by Adriano Souza Costa on 19/07/24.
//

import SwiftUI

public struct FormulateButtonField<Content: View>: View {
    
    private let validator: Validator
    private let action: () -> Void
    private let content: () -> Content
    
    public init(
        _ validator: Validator = .init(),
        action: @escaping () -> Void,
        content: @escaping () -> Content
    ) {
        self.validator = validator
        self.action = action
        self.content = content
    }
    
    public var body: some View {
        FormulateField(validator) {
            Button {
                action()
            } label: {
                content()
            }

        }
    }
    
}

#Preview {
    FormulateButtonField {
        print("Submited!")
    } content: {
        Text("Submit")
    }
}
