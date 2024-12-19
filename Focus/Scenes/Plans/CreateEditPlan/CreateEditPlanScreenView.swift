//
//  CreateEditPlanScreenView.swift
//  Focus
//
//  Created by Adriano Souza Costa on 15/07/24.
//

import SwiftUI
import FocusCore
import FamilyControls

struct CreateEditPlanScreenView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(FocusPlanStore.self) private var focusPlanStore
    
    @State private var form: CreateEditPlanForm
    @State private var isPresentRestrictions = false
    @State private var presentDeleteDialog = false
    
    private let isNew: Bool
    
    private var navigationTitle: String {
        isNew ? "New plan" : "Edit plan"
    }
    
    private var showStatusSection: Bool {
        !isNew
    }
    
    init(plan: FocusPlan?) {
        form = .init(value: plan ?? .empty)
        isNew = plan == nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    FormulateTextField(
                        "Title",
                        value: $form.value.title,
                        validator: form.titleValidator
                    )
                    FormulateDateTimeField(
                        "Start",
                        value: $form.value.start,
                        components: [.hourAndMinute]
                    )
                    FormulateDateTimeField(
                        "End",
                        value: $form.value.end,
                        components: [.hourAndMinute],
                        in: form.value.start.addingTimeInterval(15.minute)...,
                        validator: form.endValidator
                    )
                    FormulateToggleField(
                        "Enabled",
                        value: $form.value.enabled
                    )
                }
                
                Section("Days of week") {
                    DaysOfWeekField(
                        form.value.daysOfWeek.sorted()  ,
                        validator: form.daysOfWeekValidator
                    ) {
                        DaysOfWeekSelectorView(items: $form.value.daysOfWeek)
                    }
                }
                
                Section("Restrictions") {
                    FormulateButtonField {
                        isPresentRestrictions.toggle()
                    } content: {
                        HStack {
                            Text("Apps not allowed")
                            Spacer()
                            Text("\(form.value.restrictions.count)")
                        }
                        .foregroundStyle(form.value.restrictionsCount > 0 ? .red : .primary)
                    }
                }
            }
            .background(.patternBackground)
            .scrollContentBackground(.hidden)
            .onAppear {
                UIDatePicker.appearance().minuteInterval = 15
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    if !isNew {
                        Button("Delete") {
                            presentDeleteDialog.toggle()
                        }
                        .foregroundStyle(.red)
                        .confirmationDialog(
                            "Delete plan",
                            isPresented: $presentDeleteDialog,
                            titleVisibility: .visible
                        ) {
                            Button("Delete", role: .destructive) {
                                focusPlanStore.remove(form.value)
                                dismiss()
                            }
                        } message: {
                            Text("Do you really remove '\(form.value.title)'?")
                        }
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .disabled(!form.isValid)
                    .opacity(form.isValid ? 1 : 0.6)
                }
            }
            .familyActivityPicker(
                isPresented: $isPresentRestrictions,
                selection: $form.value.restrictions
            )
        }
    }
    
    // MARK: - Private Methods
    
    private func save() {
        do {
            try form.validate()
            
            if isNew {
                try focusPlanStore.insert(form.value)
            } else {
                try focusPlanStore.update(form.value)
            }
            
            dismiss()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

#Preview {
    CreateEditPlanScreenView(plan: nil)
        .environment(FocusPlanStore(.preview, setingsStore: .preview))
}
