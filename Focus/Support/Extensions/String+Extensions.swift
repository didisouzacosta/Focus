//
//  String+Extensions.swift
//  Focus
//
//  Created by Adriano Souza Costa on 14/08/24.
//

import SwiftUI

extension String {
    
    static let loaderWindowIdentifier = "loaderWindowIdentifier"
    static let licenses = "licenses"
    static let faqs = "faqs"
    static let userTerms = "user_terms"
    
    var markdown: LocalizedStringKey {
        .init(self)
    }
    
}
