//
//  FAQScreenView.swift
//  Focus
//
//  Created by Adriano Souza Costa on 15/08/24.
//

import SwiftUI
import FocusCore

struct FAQScreenView: View {
    
    // MARK: - Private Properties
    
    private var questions: [Question] = [
        .init(
            .init(localized: .whatIsFocusAndHowDoesItWorks) ,
            answer: .init(localized: .whatIsFocusAndHowDoesItWorksText)
        ),
        .init(
            .init(localized: .focusRequiresLoginOrRegistrationToWork),
            answer: .init(localized: .focusRequiresLoginOrRegistrationToWorkText)
        ),
        .init(
            .init(localized: .howDoISetUpAFocusPlan),
            answer: .init(localized: .howDoISetUpAFocusPlanText)
        ),
        .init(
            .init(localized: .whatHappensWhenIBlockAnApp),
            answer: .init(localized: .whatHappensWhenIBlockAnAppText)
        ),
        .init(
            .init(localized: .whatFeaturesAreIncludedInTheFreeVersionXSubscription),
            answer: .init(localized: .whatFeaturesAreIncludedInTheFreeVersionXSubscriptionText)
        ),
        .init(
            .init(localized: .howCanIChangeOrCancelMySubscription),
            answer: .init(localized: .howCanIChangeOrCancelMySubscriptionText)
        ),
        .init(
            .init(localized: .willFocusCollectOrStoreMyPersonalData),
            answer: .init(localized: .willFocusCollectOrStoreMyPersonalDataText)
        ),
        .init(
            .init(localized: .howDoITroubleshootIssuesWithTheApp),
            answer: .init(localized: .howDoITroubleshootIssuesWithTheAppText)
        ),
        .init(
            .init(localized: .canIUseFocusAcrossMultipleDevices),
            answer: .init(localized: .canIUseFocusAcrossMultipleDevicesText)
        ),
        .init(
            .init(localized: .whatHappensIfIUninstallFocus),
            answer: .init(localized: .whatHappensIfIUninstallFocusText)
        )
    ]
    
    // MARK: - Life Cicle
    
    var body: some View {
        List(questions, id: \.title) { question in
            NavigationLink {
                MarkdownView(question.answer)
                    .navigationBarTitleDisplayMode(.inline)
            } label: {
                Text(question.title)
            }
        }
        .navigationTitle("FAQs")
    }
    
}

#Preview {
    NavigationStack {
        FAQScreenView()
    }
}
