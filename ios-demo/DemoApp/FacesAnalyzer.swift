//
//  FacesAnalyzer.swift
//  DemoApp
//
//  Created by Danil Chernikov on 19.06.2025.
//

import UIKit
import PerchEyeFramework

struct CustomError: Error, LocalizedError, Identifiable {
    let id = UUID()
    let title: String
    let message: String
    
    var errorDescription: String? {
        return "\(title): \(message)"
    }
}

class FacesAnalyzer {
    private let perchEye: PerchEyeSwift
    
    init() {
        perchEye = PerchEyeSwift()
    }
    
    func analyzeFaces(in firstImages: [UIImage], and secondImages: [UIImage]) async throws(CustomError) -> Float {
        do {
            return try await withCheckedThrowingContinuation { [weak self] continuation in
                guard let self else { return }
                
                do {
                    perchEye.openTransaction()
                    let firstHash = try generateHash(for: firstImages, prefixString: "first")
                    
                    perchEye.openTransaction()
                    try loadImages(for: secondImages, prefixString: "second")
                    
                    let similarity = perchEye.verify(hash: firstHash)

                    continuation.resume(returning: similarity)
                } catch {
                    continuation.resume(throwing: error as? CustomError ??
                                        CustomError(title: "Analysis Error", message: error.localizedDescription))
                }
            }
        } catch {
            throw error as? CustomError ?? CustomError(title: "Analysis Error", message: error.localizedDescription)
        }
    }
    
    func loadImages(for images: [UIImage], prefixString: String) throws(CustomError) {
        if images.count == 1 {
            try evaluateImage(result: perchEye.load(image: images[0]), prefixString: prefixString)
        } else {
            var results = [ImageResult]()
            
            for image in images {
                let result = perchEye.load(image: image)
                
                switch result {
                case .sdkNotInitialized:
                    throw CustomError(title: "SDK Error", message: "SDK is not initialized.")
                case .faceNotFound:
                    results.append(result)
                case .transactionNotOpened:
                    throw CustomError(title: "Transaction Error", message: "Transaction is not opened.")
                case .internalError:
                    throw CustomError(title: "Internal Error", message: "An internal error.")
                default:
                    break
                }
            }
            
            if results.isEmpty {
                return;
            } else {
                if results.count < images.count {
                    return;
                } else {
                    guard let firstResult = results.first else {
                        throw CustomError(title: "Images Error", message: "No images provided for enrollment.")
                    }
                    
                    try evaluateImage(result: firstResult, prefixString: prefixString)
                }
            }
        }
    }
    
    func generateHash(for images: [UIImage], prefixString: String) throws(CustomError) -> String {
        if images.count == 1 {
            try evaluateImage(result: perchEye.load(image: images[0]), prefixString: prefixString)
            return perchEye.enroll()
        } else {
            var results = [ImageResult]()
            
            for image in images {
                let result = perchEye.load(image: image)
                
                switch result {
                case .sdkNotInitialized:
                    throw CustomError(title: "SDK Error", message: "SDK is not initialized.")
                case .faceNotFound:
                    results.append(result)
                case .transactionNotOpened:
                    throw CustomError(title: "Transaction Error", message: "Transaction is not opened.")
                case .internalError:
                    throw CustomError(title: "Internal Error", message: "An internal error.")
                default:
                    break
                }
            }
            
            if results.isEmpty {
                return perchEye.enroll()
            } else {
                if results.count < images.count {
                    return perchEye.enroll()
                } else {
                    guard let firstResult = results.first else {
                        throw CustomError(title: "Images Error", message: "No images provided for enrollment.")
                    }
                    
                    try evaluateImage(result: firstResult, prefixString: prefixString)
                    return ""
                }
            }
        }
    }
    
    func evaluateImage(result: ImageResult, prefixString: String) throws(CustomError) {
        switch result {
        case .sdkNotInitialized:
            throw CustomError(title: "SDK Error", message: "SDK is not initialized.")
        case .faceNotFound:
            throw CustomError(title: "Face Detection Error", message: "No face found in the \(prefixString) image.")
        case .transactionNotOpened:
            throw CustomError(title: "Transaction Error", message: "Transaction is not opened.")
        case .internalError:
            throw CustomError(title: "Internal Error", message: "An internal error.")
        default:
            return
        }
    }
}
