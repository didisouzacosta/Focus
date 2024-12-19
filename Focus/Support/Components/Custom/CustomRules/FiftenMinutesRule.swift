//
//  FiftenMinutesRule.swift
//  Formulate
//
//  Created by Adriano Souza Costa on 23/07/24.
//

import Foundation

public class FiftenMinutesRule: Rule {
    
    // MARK: - Public Variables
    
    public let message: String
    
    // MARK: - Private Variables
    
    private let firstDate: () -> Date?
    private let secondDate: () -> Date?
    
    // MARK: Life Cicle
    
    public init(
        _ firstDate: @autoclosure @escaping () -> Date?,
        secondDate: @autoclosure @escaping () -> Date?,
        message: String
    ) {
        self.firstDate = firstDate
        self.secondDate = secondDate
        self.message = message
    }
    
    // MARK: - Public Methods
    
    public func validate() throws {
        guard let first = firstDate(),
              let second = secondDate()
        else {
            return
        }
        
        if first.minutesFrom(second) < 15 {
            throw message
        }
    }
    
}


