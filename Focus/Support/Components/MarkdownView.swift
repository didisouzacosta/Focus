//
//  MarkdownView.swift
//  Focus
//
//  Created by Adriano Souza Costa on 16/08/24.
//

import SwiftUI
import MarkdownUI
import FocusCore

struct MarkdownView: View {
    
    // MARK: - Private Variables

    @State private var markdown = ""
    
    private var file: FileReader.MarkdownFile?
    
    // MARK: - Life Cicle
    
    init(_ file: FileReader.MarkdownFile) {
        self.file = file
    }
    
    init(_ value: String) {
        _markdown = .init(wrappedValue: value)
    }
    
    init(_ value: String.LocalizationValue) {
        _markdown = .init(wrappedValue: String(localized: value))
    }
    
    var body: some View {
        ScrollView {
            HStack {
                Markdown(markdown)
                    .safeAreaPadding()
                    .padding(.vertical)
                Spacer()
            }
        }
        .scrollIndicators(.hidden)
        .onAppear {
            Task { @MainActor in
                if let file {
                    markdown = try FileReader.markdown(from: file) ?? ""
                }
            }
        }
    }
    
}

#Preview("Load from text") {
    MarkdownView(.dedicationText)
}

#Preview("Load from file") {
    MarkdownView(.legalTermsOfUseText)
}
