//
//  FormulateToggleField.swift
//  Formulate
//
//  Created by Adriano Souza Costa on 19/07/24.
//

import SwiftUI

public struct FormulateToggleField: View {
    
    @Binding public var value: Bool
    
    private let title: String
    private let validator: Validator
    
    public init(
        _ title: String,
        value: Binding<Bool>,
        validator: Validator = .init()
    ) {
        _value = value
        
        self.validator = validator
        self.title = title
    }
    
    public var body: some View {
        FormulateField(validator) {
            Toggle(title, isOn: $value)
        }
    }
    
}

#Preview {
    struct Sample: View {
        @State private var enabled = true
        
        var body: some View {
            FormulateToggleField("Enabled", value: $enabled)
        }
    }
    
    return Sample()
}
