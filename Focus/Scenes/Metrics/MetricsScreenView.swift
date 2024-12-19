//
//  MetricsScreenView.swift
//  Focus
//
//  Created by Adriano Souza Costa on 15/08/24.
//

import SwiftUI
import DeviceActivity

struct MetricsScreenView: View {
    
    // MARK: - Private Variables
    
    @Environment(FocusPlanStore.self) private var focusPlanStore
    
    @State private var context: DeviceActivityReport.Context = .usageActivity
    @State private var filter = DeviceActivityFilter(
        segment: .hourly(during: Calendar.current.dateInterval(
            of: .day, for: .now
        )!),
        users: .all,
        devices: .init([.iPhone, .iPad, .mac]),
        applications: [],
        webDomains: []
    )
    
    // MARK: - Life Cicle
    
    var body: some View {
        NavigationView {
            ZStack {
                ProgressView()
                DeviceActivityReport(context, filter: filter)
            }
            .background(.patternBackground)
            .navigationTitle("Metrics")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MetricsScreenView()
        .environment(FocusPlanStore(.preview, setingsStore: .preview))
}
