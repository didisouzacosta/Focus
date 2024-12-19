//
//  Validator.swift
//  Formulate
//
//  Created by Adriano Souza Costa on 24/07/24.
//

import Foundation

@Observable
public final class Validator {
    
    public let rules: [Rule]
    public private(set) var errors = [Error]()
    
    public var isValid: Bool {
        errors.isEmpty
    }
    
    public init(_ rules: [Rule] = []) {
        self.rules = rules
    }
    
    public func validate() {
        errors = rules.compactMap { rule in
            do {
                try rule.validate()
                return nil
            } catch {
                return error
            }
        }
    }
    
}

public extension Validator {
    
    var errorsDescription: [String] {
        errors.map { $0.localizedDescription }
    }
    
}
