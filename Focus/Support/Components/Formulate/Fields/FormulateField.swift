//
//  FormulateField.swift
//  Formulate
//
//  Created by Adriano Souza Costa on 22/07/24.
//

import SwiftUI

public struct FormulateField<Content: View>: View {
    
    let validator: Validator
    let content: () -> Content
    
    private var presentErros: Bool {
        !validator.errors.isEmpty
    }
    
    public init(
        _ validator: Validator,
        content: @escaping () -> Content
    ) {
        self.validator = validator
        self.content = content
    }
    
    public var body: some View {
        HStack {
            LazyVStack(alignment: .leading, spacing: 4) {
                content()
                
                if presentErros {
                    VStack(alignment: .leading) {
                        ForEach(validator.errorsDescription, id: \.self) { error in
                            Text(error)
                                .font(.callout)
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    struct Sample:View {
        @State private var text = ""
        
        var body: some View {
            FormulateField(.init([RequiredRule(text, message: "The field is required")])) {
                TextField("Name", text: $text)
            }
        }
    }
    
    return Sample()
}


