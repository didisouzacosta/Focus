//
//  SettingsScreenView.swift
//  Focus
//
//  Created by Adriano Souza Costa on 14/08/24.
//

import SwiftUI

struct SettingsScreenView: View {
    
    @State private var isFaceIDEnabled = false
    @State private var isDenyAppRemoval = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Membership") {
                    Text("Comming soon")
                }
                
                Section("Security") {
                    Toggle("FaceID", isOn: $isFaceIDEnabled)
                        .disabled(true)
                    Toggle("Deny app removal", isOn: $isDenyAppRemoval)
                        .disabled(true)
                }
                
                Section("Frequently asked questions") {
                    NavigationLink {
                        FAQScreenView()
                    } label: {
                        Text("FAQs")
                    }
                }
                
                Section("Legal") {
                    NavigationLink {
                        MarkdownView(.legalTermsOfUseText)
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Text("Terms of Use")
                    }
                    
                    NavigationLink {
                        MarkdownView(.legalPrivacyPolicyText)
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Text("Privacy Policy")
                    }
                }
                
                Section {
                    NavigationLink {
                        MarkdownView(.dedicationText)
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Text("Dedication")
                    }
                }
                
                Section("App infos") {
                    NavigationLink {
                        LicensesScreenView()
                    } label: {
                        Text("Libraries and Licenses")
                    }
                    
                    HStack(spacing: 8) {
                        Text(Bundle.main.displayName)
                        Spacer()
                        Text("\(Bundle.main.appVersion) (\(Bundle.main.buildNumber))")
                    }
                }
            }
            .background(.patternBackground)
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .navigationTitle("Settings")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}



#Preview {
    SettingsScreenView()
}
