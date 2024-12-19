//
//  RequiredRule.swift
//  Formulate
//
//  Created by Adriano Souza Costa on 23/07/24.
//

import Foundation

public class RequiredRule<T>: Rule {
    
    // MARK: - Public Variables
    
    public let message: String
    
    // MARK: - Private Variables
    
    private let value: () -> T?
    
    // MARK: Life Cicle
    
    public init(
        _ value: @autoclosure @escaping () -> T?,
        message: String
    ) {
        self.value = value
        self.message = message
    }
    
    // MARK: - Public Methods
    
    public func validate() throws {
        if value() == nil {
            throw message
        }
    }
    
}
