//
//  FormulateDateTimeField.swift
//  Formulate
//
//  Created by Adriano Souza Costa on 19/07/24.
//

import SwiftUI

public struct FormulateDateTimeField: View {
    
    @Binding public var value: Date
    
    private let validator: Validator
    private let title: String
    private let components: DatePickerComponents
    
    private var partialRange: PartialRangeFrom<Date>?
    private var closedRange: ClosedRange<Date>?
    
    public init(
        _ title: String,
        value: Binding<Date>,
        components: DatePickerComponents = [.date, .hourAndMinute],
        validator: Validator = .init()
    ) {
        _value = value
        
        self.title = title
        self.components = components
        self.validator = validator
    }
    
    public init(
        _ title: String,
        value: Binding<Date>,
        components: DatePickerComponents = [.date, .hourAndMinute],
        in range: ClosedRange<Date>,
        validator: Validator = .init()
    ) {
        self.init(
            title,
            value: value,
            components: components,
            validator: validator
        )
        
        self.closedRange = range
    }
    
    public init(
        _ title: String,
        value: Binding<Date>,
        components: DatePickerComponents = [.date, .hourAndMinute],
        in range: PartialRangeFrom<Date>,
        validator: Validator = .init()
    ) {
        self.init(
            title,
            value: value,
            components: components,
            validator: validator
        )
        
        self.partialRange = range
    }
    
    public var body: some View {
        FormulateField(validator) {
            if let closedRange {
                DatePicker(
                    selection: $value,
                    in: closedRange,
                    displayedComponents: components
                ) {
                    Text(title)
                }
            } else if let partialRange {
                DatePicker(
                    selection: $value,
                    in: partialRange,
                    displayedComponents: components
                ) {
                    Text(title)
                }
            } else {
                DatePicker(
                    selection: $value,
                    displayedComponents: components
                ) {
                    Text(title)
                }
            }
        }
    }
    
}

#Preview {
    struct Sample: View {
        @State private var date: Date = .now
        
        var body: some View {
            FormulateDateTimeField("Start in", value: $date, components: [.date])
        }
    }
    
    return Sample()
}
