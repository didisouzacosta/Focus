//
//  SyncScreenView.swift
//  Focus
//
//  Created by Adriano Souza Costa on 14/08/24.
//

import SwiftUI

struct SyncScreenView: View {
    var body: some View {
        Rectangle()
            .fill(.patternBackground)
            .overlay {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 6)
                        .fill(.patternBlack)
                        .containerRelativeFrame(.horizontal) { size, _ in
                            size * 0.186
                        }
                    
                    ProgressView()
                }
            }
            .ignoresSafeArea()
    }
}

#Preview {
    SyncScreenView()
}
