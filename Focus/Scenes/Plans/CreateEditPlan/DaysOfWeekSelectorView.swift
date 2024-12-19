//
//  DaysOfWeekSelector.swift
//  Focus
//
//  Created by Adriano Souza Costa on 15/07/24.
//

import SwiftUI
import FocusCore

struct DaysOfWeekSelectorView: View {
    
    @Binding var items: [DayOfWeek]
    
    var body: some View {
        Form {
            Section {
                ForEach(DayOfWeek.all, id: \.self) { item in
                    Button(action: {
                        select(item)
                    }, label: {
                        HStack {
                            icon(at: item)
                                .imageScale(.large)
                            Text(item.name.capitalized)
                            Spacer()
                        }
                    })
                }
            } header: {
                HStack {
                    Text("Selected days")
                    
                    Spacer()
                    
                    Menu {
                        Button("Weekdays") {
                            items = .weekdays
                        }
                        Button("Weekend") {
                            items = .weekend
                        }
                        Button("All") {
                            items = .all
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.2.square")
                            .imageScale(.large)
                    }
                }
            }
        }
        .navigationTitle("Days of week")
    }
    
    // MARK: - Private Methods
    
    private func isSelected(_ item: DayOfWeek) -> Bool {
        items.contains(item)
    }
    
    private func icon(at item: DayOfWeek) -> Image {
        let imageName = isSelected(item) ? "checkmark.circle.fill" : "circle"
        return Image(systemName: imageName)
    }
    
    private func select(_ item: DayOfWeek) {
        if isSelected(item) {
            if items.count > 1 {
                items.removeAll { $0 == item }
            }
        } else {
            items.append(item)
        }
    }
}

#Preview {
    struct Sample: View {
        @State private var selectedItems: [DayOfWeek] = [
            .monday,
            .friday
        ]
        
        var body: some View {
            DaysOfWeekSelectorView(items: $selectedItems)
        }
    }
    
    return Sample()
}
