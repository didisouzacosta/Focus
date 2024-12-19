//
//  View+Extension.swift
//  Focus
//
//  Created by Adriano Souza Costa on 07/08/24.
//

import SwiftUI

extension View where Self: Shape {
  
    func glow(
        fill: some ShapeStyle,
        lineWidth: Double,
        lineCap: CGLineCap = .round
    ) -> some View {
        self.stroke(style: StrokeStyle(lineWidth: lineWidth / 2, lineCap: lineCap))
            .fill(fill)
            .overlay {
                self.stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: lineCap))
                    .fill(fill)
            }
            .overlay {
                self.stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: lineCap))
                    .fill(fill)
            }
    }
    
}
