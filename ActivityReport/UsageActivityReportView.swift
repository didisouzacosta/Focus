//
//  UsageActivityReportView.swift
//  ActivityReport
//
//  Created by Adriano Souza Costa on 11/08/24.
//

import SwiftUI
import FamilyControls
import Charts

struct UsageActivityReportView: View {
    
    // MARK: - Private Variables
    
    @State private var type: ReportType = .screenTime
    @State private var selected: ReportSegment?
    
    private let report: Report
    
    // MARK: - Life Cicle
    
    init(_ report: Report) {
        self.report = report
    }
    
    var body: some View {
        if report.apps.isEmpty {
            ProgressView()
        } else {
            ZStack(alignment: .top) {
                BaseView {
                    ZStack(alignment: .top) {
                        TabView(selection: $type) {
                            ForEach(ReportType.allCases, id: \.self) { type in
                                ReportList(
                                    $selected,
                                    segments: report.segments,
                                    type: type
                                )
                                .tag(type)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                    }
                    .onAppear {
                        selected = report.segments.last
                    }
                }
                
                ZStack {
                    HStack {
                        ForEach(ReportType.allCases, id: \.self) { type in
                            Circle()
                                .fill(.patternText.opacity(type == self.type ? 1 : 0.4))
                                .frame(width: 6, height: 6)
                        }
                    }
                }
                .safeAreaPadding()
            }
        }
    }
    
}

extension UsageActivityReportView {
    
    enum ReportType: Int, Hashable, CaseIterable {
        case screenTime, notification, pickups
        
        var caption: String {
            switch self {
            case .screenTime: "Screen Time"
            case .notification: "Notifications"
            case .pickups: "Pickups"
            }
        }
        
        var subTitle: String {
            switch self {
            case .screenTime: "Top of screen time usage"
            case .notification: "Top of notifications received"
            case .pickups: "Top of pickups"
            }
        }
        
        var color: Color {
            switch self {
            case .screenTime: .patternActive
            case .notification: .patternYellow
            case .pickups: .patternBlue
            }
        }
    }
    
    struct ReportList: View {
        
        @Binding private var selected: ReportSegment?
        
        private let segments: [ReportSegment]
        private let type: ReportType
        
        private var total: Double {
            selected?.total(type: type) ?? 0
        }
        
        private var apps: [AppDeviceActivity] {
            let apps = selected?.apps.merged() ?? []
            
            return switch type {
            case .screenTime:
                apps.filter { $0.duration > 0 }
                    .sorted { ($0.duration, $1.name) > ($1.duration, $0.name) }
            case .notification:
                apps.filter { $0.notifications > 0 }
                    .sorted { ($0.notifications, $1.name) > ($1.notifications, $0.name) }
            case .pickups:
                apps.filter { $0.pickups > 0 }
                    .sorted { ($0.pickups, $1.name) > ($1.pickups, $0.name) }
            }
        }
        
        init(
            _ selected: Binding<ReportSegment?>,
            segments: [ReportSegment],
            type: ReportType
        ) {
            self._selected = selected
            self.segments = segments
            self.type = type
        }
        
        var body: some View {
            if segments.isEmpty {
                ContentUnavailableView {
                    Label(
                        "No data",
                        systemImage: "hourglass"
                    )
                } description: {
                    VStack(spacing: 16) {
                        Text("No data for \(type.caption.lowercased()) yet.")
                    }
                }
            } else {
                List {
                    Section {
                        ReportChart(
                            $selected,
                            segments: segments,
                            type: type
                        )
                            .listRowInsets(
                                .init(
                                    top: 0,
                                    leading: 0,
                                    bottom: 0,
                                    trailing: 0
                                )
                            )
                    }
                    .listSectionSpacing(.compact)
                    .listRowBackground(Color.clear)
                    
                    Section {
                        if apps.isEmpty {
                            HStack {
                                Spacer()
                                Text("No data")
                                Spacer()
                            }
                            .listRowBackground(Color.clear)
                        } else {
                            ForEach(apps) { app in
                                ReportListItem(app, type: type, total: total)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .listRowSpacing(4)
                .background(.patternBackground)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .contentMargins(.vertical, 32)
            }
        }
    }
    
    struct ReportHeader: View {
        
        private let capition: String
        private let title: String
        private let subTitle: String?
        
        init(
            _ capition: String,
            title: String,
            subTitle: String? = nil
        ) {
            self.capition = capition
            self.title = title
            self.subTitle = subTitle
        }
        
        var body: some View {
            HStack {
                Spacer()
                
                VStack(alignment: .center) {
                    Text(capition)
                        .font(.callout)
                    
                    Text(title)
                        .font(.system(size: 32, weight: .bold))
                        .bold()
                    
                    if let subTitle {
                        Text(subTitle)
                            .font(.callout)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    struct ReportChart: View {
        
        @Binding private var selected: ReportSegment?
        @State private var date: Date?
        
        private let segments: [ReportSegment]
        private let type: ReportType
        
        private var title: String {
            let total = selected?.total(type: type) ?? 0
            
            return switch type {
            case .screenTime:
                total.timeFormatter(maximumUnitCount: 2)
            default:
                String(format: "%.0f", total)
            }
        }
        
        private var subTitle: String {
            if let hour = selected?.interval.start.hour {
                "\(hour)h"
            } else {
                "---"
            }
        }
        
        init(
            _ selected: Binding<ReportSegment?>,
            segments: [ReportSegment],
            type: ReportType
        ) {
            self._selected = selected
            self.segments = segments
            self.type = type
        }
        
        var body: some View {
            VStack(spacing: 32) {
                ReportHeader(type.caption, title: title, subTitle: subTitle)
                
                Chart(segments) { segment in
                    let isSame = segment.interval.start == selected?.interval.start
                    
                    LineMark(
                        x: .value("Hour", segment.interval.start, unit: .hour),
                        y: .value("Total", segment.total(type: type))
                    )
                    .lineStyle(.init(lineWidth: 1))
                    .foregroundStyle(type.color)

                    PointMark(
                        x: .value("Hour", segment.interval.start, unit: .hour),
                        y: .value("Total", segment.total(type: type))
                    )
                    .symbolSize(isSame ? 80 : 20)
                    .foregroundStyle(isSame ? .red : type.color)
                    
                    AreaMark(
                        x: .value("Hour", segment.interval.start, unit: .hour),
                        yStart: .value("Total", 0),
                        yEnd: .value("Total", segment.total(type: type))
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                type.color.opacity(0.6),
                                type.color.opacity(0)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                    if let selected {
                        RuleMark(x: .value("Hour", selected.interval.start, unit: .hour))
                            .lineStyle(.init(lineWidth: 1))
                            .foregroundStyle(.red)
                    }
                }
                .chartXSelection(value: $date)
                .chartXAxis {
                    AxisMarks { value in
                        AxisValueLabel {
                            if let value = value.as(Date.self) {
                                Text("\(value.hour)h")
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisValueLabel {
                            if let value = value.as(Double.self) {
                                let label = switch type {
                                case .screenTime: value.timeFormatter(maximumUnitCount: 1)
                                default:
                                    String(format: "%.0f", value)
                                }
                                
                                Text(label)
                            }
                        }
                    }
                }
            }
            .padding(.vertical)
            .onChange(of: date) { oldValue, newValue in
                if let segment = segments.first(where: {
                    $0.interval.start.hour == newValue?.hour ?? oldValue?.hour
                }) {
                    selected = segment
                }
            }
        }
        
    }
    
    struct ReportListItem: View {
        
        private let app: AppDeviceActivity
        private let type: ReportType
        private let total: Double
        
        private var value: Double {
            switch type {
            case .screenTime: app.duration
            case .notification: Double(app.notifications)
            case .pickups: Double(app.pickups)
            }
        }
        
        private var color: Color {
            type.color
        }
        
        private var label: String {
            switch type {
            case .screenTime:
                value.timeFormatter(maximumUnitCount: 2)
            default:
                String(format: "%.0f", value)
            }
        }
        
        init(_ app: AppDeviceActivity, type: ReportType, total: Double) {
            self.app = app
            self.type = type
            self.total = total
        }
        
        var body: some View {
            HStack(spacing: 16) {
                if let token = app.token {
                    Label(token)
                        .labelStyle(.iconOnly)
                } else {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.patternLightGray)
                        .frame(width: 32, height: 32)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(app.name)
                    
                    HStack(spacing: 8) {
                        ProgressView(
                            value: value,
                            total: total
                        )
                        .tint(color)
                        
                        Text(label)
                            .font(.footnote)
                    }
                }
            }
            .font(.callout)
            .padding(.vertical, 4)
        }
    }
    
}

fileprivate extension ReportSegment {
    
    func total(type: UsageActivityReportView.ReportType) -> Double {
        return switch type {
        case .screenTime: apps.reduce(0) { $1.duration + $0 }
        case .notification: Double(apps.reduce(0) { $1.notifications + $0 })
        case .pickups: Double(apps.reduce(0) { $1.pickups + $0 })
        }
    }
    
}

fileprivate extension [ReportSegment] {
    
    func total(by type: UsageActivityReportView.ReportType) -> Double {
        return switch type {
        case .screenTime: reduce(0) { $1.total(type: type) + $0 }
        case .notification: Double(reduce(0) { $1.total(type: type) + $0 })
        case .pickups: Double(reduce(0) { $1.total(type: type) + $0 })
        }
    }
    
}

fileprivate extension DateComponents {
    
    var timeFormatter: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: self) ?? "---"
    }
    
}

#Preview {
    UsageActivityReportView(
        .init((0...23).map { index in
            .init(
                .init(
                    start: .from(hour: index, minute: 0)!,
                    end: .from(hour: index, minute: 30)!
                ),
                apps: [
                    .init(
                        "com.youtube",
                        token: nil,
                        name: "Youtube",
                        duration: Double.random(in: 1...50).minute,
                        notifications: Int.random(in: 0...100),
                        pickups: Int.random(in: 0...100)
                    ),
                    .init(
                        "com.duolingo",
                        token: nil,
                        name: "Duolingo",
                        duration: Double.random(in: 1...50).minute,
                        notifications: Int.random(in: 0...100),
                        pickups: Int.random(in: 0...10)
                    ),
                    .init(
                        "com.focus",
                        token: nil,
                        name: "Focus",
                        duration: Double.random(in: 1...50).minute,
                        notifications: Int.random(in: 0...10),
                        pickups: Int.random(in: 0...10)
                    ),
                    .init(
                        "com.youtube2",
                        token: nil,
                        name: "Youtube",
                        duration: Double.random(in: 1...50).minute,
                        notifications: Int.random(in: 0...100),
                        pickups: Int.random(in: 0...100)
                    ),
                    .init(
                        "com.duolingo2",
                        token: nil,
                        name: "Duolingo",
                        duration: Double.random(in: 1...50).minute,
                        notifications: Int.random(in: 0...100),
                        pickups: Int.random(in: 0...10)
                    ),
                    .init(
                        "com.focus2",
                        token: nil,
                        name: "Focus",
                        duration: Double.random(in: 1...50).minute,
                        notifications: Int.random(in: 0...10),
                        pickups: Int.random(in: 0...10)
                    ),
                    .init(
                        "com.youtube3",
                        token: nil,
                        name: "Youtube",
                        duration: Double.random(in: 1...50).minute,
                        notifications: Int.random(in: 0...100),
                        pickups: Int.random(in: 0...100)
                    ),
                    .init(
                        "com.duolingo3",
                        token: nil,
                        name: "Duolingo",
                        duration: Double.random(in: 1...50).minute,
                        notifications: Int.random(in: 0...100),
                        pickups: Int.random(in: 0...10)
                    ),
                    .init(
                        "com.focus3",
                        token: nil,
                        name: "Focus",
                        duration: Double.random(in: 1...50).minute,
                        notifications: Int.random(in: 0...10),
                        pickups: Int.random(in: 0...10)
                    )
                ]
            )
        })
    )
}
