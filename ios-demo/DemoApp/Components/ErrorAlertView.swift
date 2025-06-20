//
//  ErrorAlertView.swift
//  DemoApp
//
//  Created by Danil Chernikov on 19.06.2025.
//

import SwiftUI

extension View {
    func errorAlert(_ error: Binding<CustomError?>) -> some View {
        self.alert(error.wrappedValue?.title ?? "",
                   isPresented: .constant(error.wrappedValue != nil)) {
            Button("OK") {
                error.wrappedValue = nil
            }
        } message: {
            Text(error.wrappedValue?.message ?? "")
        }
    }
}
