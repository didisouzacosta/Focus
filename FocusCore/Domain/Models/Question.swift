//
//  Question.swift
//  FocusCore
//
//  Created by Adriano Souza Costa on 15/08/24.
//

import Foundation

public struct Question: Decodable {
    
    public let title: String
    public let answer: String
    
    public init(_ title: String, answer: String) {
        self.title = title
        self.answer = answer
    }
    
}
