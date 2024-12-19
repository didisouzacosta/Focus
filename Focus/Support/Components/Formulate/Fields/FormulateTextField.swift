//
//  FormulateTextField.swift
//  Formulate
//
//  Created by Adriano Souza Costa on 19/07/24.
//

import SwiftUI

public struct FormulateTextField: View {
    
    @Binding public var value: String
    
    private let title: String
    private let keyboardType: UIKeyboardType
    private let validator: Validator
    
    public init(
        _ title: String,
        value: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        validator: Validator = .init()
    ) {
        _value = value
        
        self.validator = validator
        self.title = title
        self.keyboardType = keyboardType
    }
    
    public var body: some View {
        FormulateField(validator) {
            TextField(title, text: $value)
                .keyboardType(keyboardType)
        }
    }
    
}

#Preview {
    struct Sample: View {
        @State private var text = ""
        
        var body: some View {
            FormulateTextField("Name", value: $text)
        }
    }
    
    return Sample()
}
