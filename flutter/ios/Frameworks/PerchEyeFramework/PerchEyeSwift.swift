//
//  PerchEyeSwift.swift
//  perch-eye-ios
//
//  Created by Sergey Pritula on 26.05.2025.
//

import UIKit

public final class PerchEyeSwift {

    fileprivate let bridge = PerchEyeBridge()

    public init() {
        bridge.perchInit()
    }
    
    deinit {
        bridge.destroy()
    }
    
    /// Opens a transaction required before loading or comparing images.
    public func openTransaction() {
        bridge.openTransaction()
    }

    /// Loads an image into the PerchEye SDK for processing.
    /// - Parameter image: The `UIImage` to be loaded.
    /// - Returns: An `ImageResult` indicating the success or failure of the image loading operation.
    @discardableResult
    public func load(image: UIImage) -> ImageResult {
        return bridge.load(image)
    }
    
    /// Verifies an image against a given hash string.
    /// Important note: At the end of processing this method, the 'Transaction' will be closed.
    /// - Parameter hash: A string representing the hash to compare against.
    /// - Returns: A float value representing the similarity score between the image and the hash.
    public func verify(hash: String) -> Float {
        return bridge.verify(hash)
    }

    /// Compares an array of images with a given hash string.
    /// - Parameters:
    ///   - images: An array of `UIImage` objects to compare.
    ///   - hash: A string representing the hash to compare against.
    public func compare(images: [UIImage], withHash hash: String) -> Float {
        return bridge.compare(images, withHash: hash)
    }

    /// Evaluates an array of images and returns a combined Base64-encoded hash.
    /// Important note: At the end of processing this method, the 'Transaction' will be closed.
    /// - Parameter images: An array of `UIImage` objects to evaluate.
    /// - Returns: A string representing the hash of the evaluated images.
    public func evaluate(_ images: [UIImage]) -> String {
        return bridge.evaluate(with: images)
    }

    /// Enrolls the currently loaded image and returns a Base64-encoded hash.
    /// - Returns: A string representing the hash of the enrolled images.
    public func enroll() -> String {
        return bridge.enroll()
    }
    
    /// Destroys the current instance of `PerchEyeSDK`.
    public func destroy() {
        bridge.destroy()
    }
}
