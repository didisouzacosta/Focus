//
//  FileReader+Extension.swift
//  Focus
//
//  Created by Adriano Souza Costa on 16/08/24.
//

import Foundation
import FocusCore

extension FileReader {
    
    struct MarkdownFile {
        let name: String
    }
    
    static func markdown(from file: MarkdownFile) throws -> String? {
        try content(file.name, withExtension: "md")
    }
    
}
