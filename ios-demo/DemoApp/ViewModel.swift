//
//  ViewModel.swift
//  DemoApp
//
//  Created by Danil Chernikov on 19.06.2025.
//

import UIKit

class ViewModel: ObservableObject {
    private let facesAnalyzer: FacesAnalyzer
    
    @Published var firstImagesGroup: [UIImage] {
        didSet {
            similarityScore = .none
        }
    }
    
    @Published var secondImagesGroup: [UIImage] {
        didSet {
            similarityScore = .none
        }
    }
    
    @Published var error: CustomError?
    @Published var similarityScore: Float?
    
    init() {
        facesAnalyzer = FacesAnalyzer()
        firstImagesGroup = []
        secondImagesGroup = []
    }
    
    static let threshold: Float = 0.8
    
    func hasSelectedImages() -> Bool {
        !firstImagesGroup.isEmpty || !secondImagesGroup.isEmpty
    }
    
    func resetImages() {
        firstImagesGroup.removeAll()
        secondImagesGroup.removeAll()
        similarityScore = .none
    }
    
    func compareImages() async {
        guard !firstImagesGroup.isEmpty, !secondImagesGroup.isEmpty else {
            error = CustomError(title: "Images Missing", message: "Please select both images to compare.")
            return
        }
        
        do {
            let score = try await facesAnalyzer.analyzeFaces(in: firstImagesGroup, and: secondImagesGroup)
            await MainActor.run { [weak self] in
                self?.similarityScore = score
            }
        } catch {
            await MainActor.run { [weak self] in
                self?.error = error
            }
        }
    }
}
