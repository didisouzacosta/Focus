//
//  PlanCard.swift
//  Focus
//
//  Created by Adriano Souza Costa on 12/07/24.
//

import SwiftUI
import FocusCore

struct PlanCard: View {
    
    let plan: FocusPlan
    let status: PlanCardStatus
    let actionHandler: () -> Void
    
    @State private var angleAnimation: Double = 0
    
    var body: some View {
        Button(action: {
            actionHandler()
        }, label: {
            VStack(alignment: .leading, spacing: status.internalSpacing) {
                HStack(alignment: .top) {
                    Text(plan.title)
                        .bold()
                        .font(status.titleSize)
                    Spacer()
                    HStack(spacing: 2) {
                        Image(systemName: "lock.shield")
                        Text("\(plan.restrictionsCount)")
                    }
                    .padding(.top, 2)
                }
                .foregroundStyle(.patternText)
                
                HStack(alignment: .center) {
                    HStack(spacing: 6) {
                        Text(plan.start, style: .time)
                            .bold()
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .foregroundStyle(status.cardActiveTextColor)
                            .background(status.cardActiveColor)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        DotsView(animated: status == .running, lenght: 3)
                            .foregroundStyle(status.cardActiveColor)
                        
                        Text(plan.end, style: .time)
                            .bold()
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .foregroundStyle(status.cardActiveTextColor)
                            .background(status.cardActiveColor)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Spacer()
                }
                .font(.footnote)
                
                HStack(spacing: 8) {
                    ForEach(plan.daysOfWeek.sorted(), id: \.self) { day in
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
            .padding()
            .background(.patternCard)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                ZStack {
                    if status.isRunning {
                        RoundedRectangle(cornerRadius: 16)
                            .glow(
                                fill: AngularGradient(
                                    gradient: .pattern,
                                    center: .center,
                                    angle: .degrees(angleAnimation)
                                ),
                                lineWidth: status.isRunning ? 2 : 0
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .animation(
                                .linear(duration: 2).repeatForever(autoreverses: false),
                                value: angleAnimation
                            )
                    }
                }
                .drawingGroup()
            )
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 4)
            .opacity(status.opacity)
        })
        .buttonStyle(.plain)
        .scaleEffect(status.isRunning ? 1 : 0.94)
        .onAppear {
            angleAnimation = status.isRunning ? 360 : 0
        }
    }
}

#Preview("Running") {
    ZStack {
        Color(.tertiarySystemFill)
        
        PlanCard(
            plan: .init(
                "Sample",
                start: .now,
                end: .now.addingTimeInterval(15.minute),
                daysOfWeek: .all,
                enabled: true
            ),
            status: .running
        ) { }
        .safeAreaPadding()
    }
}

#Preview("Stand-By") {
    ZStack {
        Color(.tertiarySystemFill)
        
        PlanCard(
            plan: .init(
                "Sample",
                start: .now,
                end: .now.addingTimeInterval(15.minute),
                daysOfWeek: .all,
                enabled: true
            ),
            status: .standby
        ) { }
            .safeAreaPadding()
    }
}

#Preview("Disabled") {
    ZStack {
        Color(.tertiarySystemFill)
        
        PlanCard(
            plan: .init(
                "Sample",
                start: .now,
                end: .now.addingTimeInterval(15.minute),
                daysOfWeek: .all,
                enabled: false
            ),
            status: .disabled
        ) { }
            .safeAreaPadding()
    }
}
