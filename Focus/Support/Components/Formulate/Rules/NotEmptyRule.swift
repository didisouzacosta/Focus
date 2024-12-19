//
//  SFNotEmptyRule.swift
//  Formulate
//
//  Created by Adriano Souza Costa on 23/07/24.
//

import Foundation

public class NotEmptyRule<T: Emptable>: Rule {
    
    // MARK: - Public Variables
    
    public let message: String
    
    // MARK: Private Variables
    
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
        if value()?.isEmpty ?? true {
            throw message
        }
    }
    
}

public protocol Emptable {
    var isEmpty: Bool { get }
}

extension String: Emptable {}
extension Data: Emptable {}
extension Array: Emptable {}
