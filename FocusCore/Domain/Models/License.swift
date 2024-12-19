//
//  License.swift
//  FocusCore
//
//  Created by Adriano Souza Costa on 15/08/24.
//

import Foundation

public struct License: Decodable {
    
    public let title: String
    public let text: String
    
    public init(_ title: String, text: String) {
        self.title = title
        self.text = text
    }
    
}
