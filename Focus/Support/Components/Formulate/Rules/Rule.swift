//
//  Rule.swift
//  Formulate
//
//  Created by Adriano Souza Costa on 23/07/24.
//

import Foundation

public protocol Rule {
    
    var message: String { get }
    
    func validate() throws
    
}
