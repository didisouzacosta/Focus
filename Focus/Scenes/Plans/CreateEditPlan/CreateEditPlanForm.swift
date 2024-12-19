//
//  CreateEditPlanForm.swift
//  Focus
//
//  Created by Adriano Souza Costa on 23/07/24.
//

import Foundation
import FocusCore

final class CreateEditPlanForm: Formulate<FocusPlan> {
    
    // MARK: - Public Variables
    
    lazy private(set) var titleValidator = Validator(
        [
            NotEmptyRule(
                self.value.title,
                message: "Title cannot be empty"
            )
        ]
    )
    
    lazy private(set) var endValidator = Validator(
        [
            DateGreaterThanRule(
                self.value.end,
                secondDate: self.value.start,
                message: "The end time must be greater than the start time."
            ),
            FiftenMinutesRule(
                self.value.end,
                secondDate: self.value.start,
                message: "The end time must be greater than 15 minutes of the start time."
            )
        ]
    )
    
    lazy private(set) var daysOfWeekValidator = Validator(
        [
            NotEmptyRule(
                self.value.daysOfWeek,
                message: "Days of week cannot be empty"
            )
        ]
    )
    
    override var validators: [Validator] {
        [
            titleValidator,
            endValidator,
            daysOfWeekValidator
        ]
    }
    
    // MARK: - Public Methods
    
    override func changed(newValue: FocusPlan, oldValue: FocusPlan) {
        if newValue.end.minutesFrom(newValue.start) < 15 {
            value.end = newValue.start.addingTimeInterval(15.minute)
        }
    }
    
}
