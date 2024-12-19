//
//  PlansListScreenView.swift
//  Focus
//
//  Created by Adriano Souza Costa on 08/07/24.
//

import SwiftUI
import FocusCore

struct PlansListScreenView: View {
    
    @Environment(FocusPlanStore.self) private var focusPlanStore
    
    @State private var isPresentNewPlan = false
    @State private var selectedPlan: FocusPlan?
    
    private var data: [(items: [FocusPlan], status: PlanCardStatus)] {
        [
            (focusPlanStore.runningPlans, .running),
            (focusPlanStore.nextPlans, .next),
            (focusPlanStore.standByPlans, .standby),
            (focusPlanStore.disabledPlans, .disabled)
        ].filter { !$0.items.isEmpty }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if !focusPlanStore.hasPlans {
                    ContentUnavailableView {
                        Label(
                            "No plans yet",
                            systemImage: "lock.shield"
                        )
                    } description: {
                        VStack(spacing: 16) {
                            Text("Start a new plan now!")
                            Button(action: {
                                isPresentNewPlan.toggle()
                            }) {
                                Text("\(Image(systemName: "plus")) New plan")
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .buttonStyle(FocusButtonStyle())
                        }
                    }
                } else {
                    List(data, id: \.status) { touple in
                        Section {
                            ForEach(touple.items, id: \.id) { plan in
                                PlanCard(plan: plan, status: touple.status) {
                                    selectedPlan = plan
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                            }
                        } header: {
                            Text(touple.status.rawValue.capitalized)
                                .font(.headline)
                                .padding(.horizontal)
                                .padding(.bottom, 4)
                        }
                        .listRowInsets(.init(top: touple.status.isRunning ? 4 : 0, leading: 0, bottom: touple.status.isRunning ? 4 : 0, trailing: 0))
                        .listSectionSeparator(.hidden)
                        .headerProminence(.increased)
                    }
                    .listStyle(.grouped)
                    .scrollIndicators(.hidden)
                    .background(.patternBackground)
                    .scrollContentBackground(.hidden)
                    .safeAreaPadding()
                    .safeAreaInset(edge: .bottom) {
                        Button {
                            isPresentNewPlan.toggle()
                        } label: {
                            Text("\(Image(systemName: "plus")) New plan")
                                .font(.headline)
                                .padding(.vertical, 16)
                                .padding(.horizontal, 32)
                                .foregroundStyle(.patternWhite)
                                .background(.patternActive)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 6)
                        .safeAreaPadding()
                    }
                    .animation(.spring, value: focusPlanStore.runningPlans)
                    .animation(.spring, value: focusPlanStore.standByPlans)
                    .animation(.spring, value: focusPlanStore.nextPlans)
                    .animation(.spring, value: focusPlanStore.disabledPlans)
                }
            }
            .navigationTitle("Plans")
            .toolbarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $isPresentNewPlan) {
            CreateEditPlanScreenView(plan: nil)
        }
        .sheet(item: $selectedPlan) { plan in
            CreateEditPlanScreenView(plan: plan)
        }
    }
    
}

#Preview("Preview") {
    PlansListScreenView()
        .environment(FocusPlanStore(.preview, setingsStore: .preview))
        
}

#Preview("Editable preview") {
    struct Sample: View {
        private let sharedData = SharedData.preview
        
        private func enabledActivities() {
            sharedData.activities = Set(sharedData.plans.map { $0.activityName.rawValue })
        }
        
        var body: some View {
            VStack(spacing: 16) {
                PlansListScreenView()
                    .onChange(of: sharedData.plans) { _, _ in
                        enabledActivities()
                    }
                
                Button(action: {
                    if sharedData.activities.isEmpty {
                        enabledActivities()
                    } else {
                        sharedData.activities = []
                    }
                }, label: {
                    Text("Toggle activities")
                })
                .buttonStyle(BorderedButtonStyle())
            }
        }
    }
    
    return Sample()
        .environment(FocusPlanStore(.preview, setingsStore: .preview))
        
}
