//
//  BaseView.swift
//  Focus
//
//  Created by Adriano Souza Costa on 01/09/24.
//

import SwiftUI

struct BaseView<Content: View>: View {
    
    private let content: () -> Content
    private let height: CGFloat = 32
    
    init(_ content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ZStack {
            ZStack {
                ZStack {
                    content()
                }
                
                ZStack {
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(
                                Gradient(
                                    colors: [
                                        .patternBackground,
                                        .patternBackground.opacity(0)
                                    ]
                                )
                            )
                            .frame(height: height)
                        
                        Spacer()
                        
                        Rectangle()
                            .fill(
                                Gradient(
                                    colors: [
                                        .patternBackground.opacity(0),
                                        .patternBackground
                                    ]
                                )
                            )
                            .frame(height: height)
                    }
                }
            }
        }
        .background(.patternBackground)
    }
}

#Preview {
    BaseView {
        Rectangle()
            .fill(.red)
            .overlay {
                Text("Test")
            }
    }
}
