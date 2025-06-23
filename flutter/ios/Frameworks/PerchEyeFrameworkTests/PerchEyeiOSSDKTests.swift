//
//  PerchEyeiOSSDKTests.swift
//  perch-eye-iosTests
//
//  Created by Danil Chernikov on 06.06.2025.
//

import XCTest
@testable import PerchEyeFramework

final class PerchEyeiOSSDKTests: XCTestCase {
    private var bridge: PerchEyeSwift?
        
    func testSuccessfulLoadImage() {
        bridge = useSDK { lib in
            guard let image = Self.uiImage(named: "test/img_2") else {
                XCTFail("Failed to load image")
                return
            }
            
            lib.openTransaction()
            
            switch lib.load(image: image) {
            case .success:
                XCTAssert(true, "Image loaded successfully")
            default:
                XCTFail("Image loading failed")
            }
        }
    }
    
    func testCompareSingleSame() {
        bridge = useSDK { lib in
            guard let image = Self.uiImage(named: "test/img_2") else {
                XCTFail("Failed to load image")
                return
            }
            
            let startTime = Self.currentTimeMillis
            let width = image.size.width
            let height = image.size.height
            
            lib.openTransaction()
            lib.load(image: image)
            let hash = lib.enroll()
            let evaluateTime = Self.currentTimeMillis - startTime
            
            lib.openTransaction()
            lib.load(image: image)
            let similarity = lib.verify(hash: hash)
            let compareTime = Self.currentTimeMillis - startTime - evaluateTime
            
            print("\(Self.tag) compareSingleSame. Input: \(width)x\(height) similarity \(similarity); evaluateTime=\(evaluateTime)ms; compareTime=\(compareTime)ms")
            XCTAssert(similarity > Self.threshold, "Images are not similar enough: \(similarity)")
        }
    }
    
    func testCompareSingleDifferent() {
        bridge = useSDK { lib in
            guard let image1 = Self.uiImage(named: "test/im_201"),
                  let image2 = Self.uiImage(named: "test/img_13") else {
                XCTFail("Failed to load images")
                return
            }
            
            lib.openTransaction()
            print("\(Self.tag) compareSingeDiff. add image1 \(lib.load(image: image1))")
            let hash = lib.enroll()
            
            lib.openTransaction()
            print("\(Self.tag) compareSingeDiff. add image2 \(lib.load(image: image2))")
            let similarity = lib.verify(hash: hash)
            
            print("\(Self.tag) compareSingleDifferent. similarity \(similarity)")
            XCTAssert(similarity < Self.threshold, "Images are too similar: \(similarity)")
        }
    }
    
    func testCompareSingleSimilar() {
        bridge = useSDK { lib in
            guard let image1 = Self.uiImage(named: "test/im_201"),
                  let image2 = Self.uiImage(named: "test_set_160/im_15") else {
                XCTFail("Failed to load images")
                return
            }
            
            lib.openTransaction()
            lib.load(image: image1)
            let hash = lib.enroll()
            
            lib.openTransaction()
            lib.load(image: image2)
            let similarity = lib.verify(hash: hash)
            
            print("\(Self.tag) compareSingeSimilar. similarity \(similarity)")
            XCTAssert(similarity > Self.threshold, "Face not matching: \(similarity)")
        }
    }
    
    func testCompareSingleSimilarArray() {
        bridge = useSDK { lib in
            guard let image1 = Self.uiImage(named: "test/im_201"),
                  let image2 = Self.uiImage(named: "test_set_160/im_15") else {
                XCTFail("Failed to load images")
                return
            }
            
            lib.openTransaction()
            lib.load(image: image1)
            let hash = lib.enroll()
            
            
            lib.openTransaction()
            lib.load(image: image2)
            let similarity = lib.verify(hash: hash)

            print("\(Self.tag) compareSingeSimilarArray. similarity \(similarity)")
            XCTAssert(similarity > Self.threshold, "Face not matching: \(similarity)")
        }
    }
    
    func testComprateThreeSimilar() {
        bridge = useSDK { lib in
            lib.openTransaction()
            let firstImages = ["test/test_1", "test/test_2", "test/test_3"]
            let firstLoadedImages = firstImages.compactMap { Self.uiImage(named: $0) }
            
            guard firstImages.count == firstLoadedImages.count else {
                XCTFail("Failed to load all images")
                return
            }
            
            firstLoadedImages.forEach {
                lib.load(image: $0)
            }
            
            let hash = lib.enroll()
            
            let secondImages = ["test/test_4", "test/test_5", "test/test_6"]
            let secondLoadedImages = secondImages.compactMap { Self.uiImage(named: $0) }
            
            guard secondImages.count == secondLoadedImages.count else {
                XCTFail("Failed to load all images")
                return
            }
            
            lib.openTransaction()
            
            secondLoadedImages.forEach {
                lib.load(image: $0)
            }
            
            let similarity = lib.verify(hash: hash)
            print("\(Self.tag) compareThreeSimilar. similarity \(similarity)")
            XCTAssert(similarity > Self.threshold, "Faces not matching: \(similarity)")
        }
    }
    
    func testRun20EnrollVerify() {
        bridge = useSDK { lib in
            guard let image1 = Self.uiImage(named: "test/test_1"),
                  let image2 = Self.uiImage(named: "test/test_2"),
                  let image3 = Self.uiImage(named: "test/test_6") else {
                XCTFail("Failed to load images")
                return
            }
            
            let startTime = Self.currentTimeMillis
            var similarity: Float = 0
            
            Array(0..<20).forEach { _ in
                lib.openTransaction()
                lib.load(image: image1)
                lib.load(image: image2)
                let hash = lib.enroll()
                
                lib.openTransaction()
                lib.load(image: image3)
                similarity = lib.verify(hash: hash)
            }
            
            print("\(Self.tag) run20EnrollVerify. similarity=\(similarity); time \(Self.formatTimeWithMillis(Self.currentTimeMillis - startTime))")
            XCTAssertTrue(true)
        }
    }
    
    func testUseSDKUnitialized() {
        let sdk = PerchEyeSwift()
        
        guard let image = Self.uiImage(named: "test/im_201") else {
            XCTFail("Failed to load image")
            return
        }
        
        let result = sdk.load(image: image)
        let hash = sdk.enroll()
        
        print("\(Self.tag) useSDKUnitialized. add image status \(result)")
        XCTAssertTrue(hash.isEmpty, "Hash not empty: \(hash)")
    }
    
    func testUseTransactionUnitialized() {
        bridge = useSDK { lib in
            guard let image = Self.uiImage(named: "test/im_201") else {
                XCTFail("Failed to load image")
                return
            }
            
            print("\(Self.tag) useTransactionUninitialized. add image status \(lib.load(image: image))")
            let hash = lib.enroll()
            
            print("\(Self.tag) useTransactionUninitialized. hash: \(hash)")
            XCTAssertTrue(hash.isEmpty, "Hash not empty: \(hash)")
        }
    }
    
    func testEnrollWithEmptySession() {
        bridge = useSDK { lib in
            let hash = lib.enroll()
            print("\(Self.tag) enrollWithEmptySession. hash: \(hash)")
            XCTAssertTrue(hash.isEmpty, "Hash not empty: \(hash)")
        }
    }
    
    func testAddNoFaceImage() {
        bridge = useSDK { lib in
            guard let image = Self.uiImage(named: "test/img_no_face") else {
                XCTFail("Failed to load image")
                return
            }
            
            lib.openTransaction()
            let result = lib.load(image: image)
            
            print("\(Self.tag) addNoFaceImage. imageStatus: \(result)")
            XCTAssertEqual(result, .faceNotFound, "Face not found")
        }
    }
    
    func testVerifyWithEmptySession() {
        bridge = useSDK { lib in
            let similarity = lib.verify(hash: "xxxx")
            print("\(Self.tag) verifyWithEmptySession. similarity: \(similarity)")
            XCTAssertTrue(similarity < Self.threshold, "Face found!")
        }
    }
    
    // MARK: - Helper
        
    static var currentTimeMillis: Int64 { UnitTestsHelper.currentTimeMillis() }
    
    static var tag: String = "FACE_TEST"
    
    static var threshold: Float = 0.7
    
    class func uiImage(named name: String) -> UIImage? {
        UnitTestsHelper.uiImage(named: name)
    }
    
    class func formatTimeWithMillis(_ millis: Int64) -> String {
        UnitTestsHelper.formatTimeWithMillis(millis)
    }
    
    func useSDK(_ builder: (PerchEyeSwift) -> Void) -> PerchEyeSwift {
        let sdk = PerchEyeSwift()
        builder(sdk)
        sdk.destroy()
        return sdk
    }
}
