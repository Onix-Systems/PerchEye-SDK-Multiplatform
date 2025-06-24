//
//  PerchEyeModule.swift
//  PerchEye
//
//  Created by Ruslan on 24.06.2025.
//

import Foundation
import PerchEyeFramework
import React

@objc(PerchEyeModule)
class PerchEyeModule: NSObject {
  private var perchEye: PerchEyeSwift? = nil

  @objc
  func initSDK(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    perchEye = PerchEyeSwift()
    resolve(nil)
  }

  @objc
  func destroy(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    perchEye?.destroy()
    perchEye = nil
    resolve(nil)
  }

  @objc
  func openTransaction(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    perchEye?.openTransaction()
    resolve(nil)
  }

  @objc
  func addImage(_ params: NSDictionary, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    guard let base64 = params["img"] as? String,
          let data = Data(base64Encoded: base64),
          let image = UIImage(data: data) else {
      resolve("INTERNAL_ERROR")
      return
    }

    let res = perchEye?.load(image: image)
    resolve(res?.rawValue ?? "INTERNAL_ERROR")
  }

  @objc
  func enroll(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    let hash = perchEye?.enroll() ?? ""
    resolve(hash)
  }

  @objc
  func verify(_ params: NSDictionary, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    let hash = params["hash"] as? String ?? ""
    let score = perchEye?.verify(hash: hash) ?? 0.0
    resolve(score)
  }

  @objc
  func evaluate(_ params: NSDictionary, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    guard let arr = params["images"] as? [String] else {
      reject("INVALID_ARGUMENT", "Images array missing", nil)
      return
    }

    let images = arr.compactMap { Data(base64Encoded: $0) }.compactMap { UIImage(data: $0) }

    if images.isEmpty {
      reject("NO_VALID_IMAGES", "Images not decodable", nil)
      return
    }

    perchEye?.openTransaction()
    let result = perchEye?.evaluate(images) ?? ""
    resolve(result)
  }

  @objc
  func compareList(_ params: NSDictionary, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    guard let arr = params["images"] as? [String],
          let hash = params["hash"] as? String else {
      reject("INVALID_ARGUMENT", "Missing inputs", nil)
      return
    }

    let images = arr.compactMap { Data(base64Encoded: $0) }.compactMap { UIImage(data: $0) }

    perchEye?.openTransaction()
    let sim = perchEye?.compare(images: images, withHash: hash) ?? 0.0
    resolve(sim)
  }
}
