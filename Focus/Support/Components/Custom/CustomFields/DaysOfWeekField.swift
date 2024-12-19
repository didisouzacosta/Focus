//
//  DaysOfWeekField.swift
//  Focus
//
//  Created by Adriano Souza Costa on 23/07/24.
//

import SwiftUI
import FocusCore

struct DaysOfWeekField<Content: View>: View {
    
    private let daysOfWeek: [DayOfWeek]
    private let validator: Validator
    private let content: () -> Content
    
    init(
        _ daysOfWeek: [DayOfWeek],
        validator: Validator = .init(),
        content: @escaping () -> Content
    ) {
        self.daysOfWeek = daysOfWeek
        self.validator = validator
        self.content = content
    }
    
    var body: some View {
        FormulateField(validator) {
            NavigationLink {
                content()
            } label: {
                ForEach(daysOfWeek, id: \.self) { day in
                    let isSameDay = day.rawValue == Date.now.weekday
                    
                    Circle()
                        .stroke(.gray, lineWidth: isSameDay ? 0.8 : 0)
                        .fill(Color(.tertiarySystemFill))
                        .frame(width: 30, height: 30)
                        .overlay {
                            Text(day.abbr)
                                .font(.caption2)
                        }
                }
            }
        }
    }
    
}

#Preview {
    DaysOfWeekField(.all) {
        Text("Test")
    }
}
