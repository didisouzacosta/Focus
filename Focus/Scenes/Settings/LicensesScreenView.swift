//
//  LicensesScreenView.swift
//  Focus
//
//  Created by Adriano Souza Costa on 15/08/24.
//

import SwiftUI
import FocusCore

struct LicensesScreenView: View {
    
    // MARK: - Private Properties
    
    @State private var licenses = [License]()
    
    // MARK: - Life Cicle
    
    var body: some View {
        List(licenses, id: \.title) { license in
            NavigationLink {
                MarkdownView(license.text)
                    .navigationBarTitleDisplayMode(.inline)
            } label: {
                Text(license.title)
            }
        }
        .navigationTitle("Licenses")
        .onAppear {
            loadLicenses()
        }
    }
    
    // MARK: - Private Methods
    
    private func loadLicenses() {
        Task { @MainActor in
            let response: [License] = (try FileReader.data(.licenses, ofType: "json")) ?? []
            licenses = response.sorted(by: { $0.title < $1.title })
        }
    }
    
}

#Preview {
    NavigationStack {
        LicensesScreenView()
    }
}
