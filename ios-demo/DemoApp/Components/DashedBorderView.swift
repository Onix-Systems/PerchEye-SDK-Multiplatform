//
//  DashedBorderView.swift
//  DemoApp
//
//  Created by Danil Chernikov on 19.06.2025.
//

import SwiftUI

extension View {
    func dashedBorder(color: Color,
                      lineWidth: CGFloat = 2,
                      dash: [CGFloat] = [6, 3], cornerRadius: CGFloat = 8) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, dash: dash))
                .foregroundColor(color)
        )
    }
}
