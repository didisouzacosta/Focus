//
//  Formulate.swift
//  Formulate
//
//  Created by Adriano Souza Costa on 22/07/24.
//

import Foundation

@Observable
open class Formulate<T: Equatable> {
    
    // MARK: - Public Variables
    
    final public var value: T {
        didSet {
            guard value != oldValue else { return }
            changed(newValue: value, oldValue: oldValue)
            try? validate()
        }
    }
    
    open var validators: [Validator] {
        []
    }
    
    final public var errors: [Error] {
        validators.flatMap { $0.errors }
    }
    
    final public var isValid: Bool {
        validators.allSatisfy { $0.isValid }
    }
    
    // MARK: - Life Cicle
    
    public init(value: T) {
        self.value = value
        try? validate()
    }
    
    // MARK: - Open Methods
    
    open func changed(newValue: T, oldValue: T) {}
    
    // MARK: - Public Methods
    
    final public func validate() throws {
        validators.forEach { $0.validate() }
        
        if let firstError = errors.first {
            throw firstError
        }
    }
    
}
