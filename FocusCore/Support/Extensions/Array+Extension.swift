//
//  Array+Extension.swift
//  Focus
//
//  Created by Adriano Souza Costa on 14/07/24.
//

import Foundation

extension Array where Element: Equatable {
    
    func random(startIn: Int = 0) -> Self {
        guard let random = (startIn...(count - 1)).randomElement() else { return self }
        return Array(shuffled().prefix(random))
    }
    
}
