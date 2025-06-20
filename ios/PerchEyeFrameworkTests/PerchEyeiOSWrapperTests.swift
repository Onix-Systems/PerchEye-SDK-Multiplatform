//
//  PerchEyeiOSWrapperTests.swift
//  perch-eye-iosTests
//
//  Created by Danil Chernikov on 06.06.2025.
//

import XCTest
@testable import PerchEyeFramework

final class PerchEyeiOSWrapperTests: XCTestCase {
    private var bridge: PerchEyeSwift?
    
    func testCompareSingleSame() {
        bridge = useSDK {
            guard let face = Self.uiImage(named: "test_set_160/im_1") else {
                XCTFail("Failed to load image")
                return
            }
            
            let start = Self.currentTimeMillis
            let hash = $0.evaluate([face])
            let evalTime = Self.currentTimeMillis - start
            let similarity = $0.compare(images: [face], withHash: hash)
            let compareTime = Self.currentTimeMillis - start - evalTime

            print("\(Self.tag) compareSingleSame. similarity \(similarity); evalTime=\(evalTime)s; compareTime=\(compareTime)s")
            print("\(Self.tag) compareSingleSame. hash = \(hash)")
            XCTAssertTrue(similarity > Self.threshold, "Face not matching: \(similarity)")
        }
    }
    
    
    func testCompareWrongSizedBitmaps() {
        bridge = useSDK {
            guard let face1 = Self.uiImage(named: "test/im_201"),
                  let face2 = Self.uiImage(named: "test/im_200") else {
                XCTFail("Failed to load images")
                return
            }

            let hash = $0.evaluate([face1])
            let similarity = $0.compare(images: [face2], withHash: hash)

            print("\(Self.tag) compareWrongSizedBitmaps. hash: \(hash), similarity \(similarity)")
            XCTAssertTrue(similarity < Self.threshold, "Face match: \(similarity)")
        }
    }
    
    func testCompareSingleSimilar() {
        bridge = useSDK {
            guard let face1 = Self.uiImage(named: "test_set_160/im_1"),
                  let face2 = Self.uiImage(named: "test_set_160/im_2") else {
                XCTFail("Failed to load images")
                return
            }

            let hash = $0.evaluate([face1])
            let similarity = $0.compare(images: [face2], withHash: hash)

            print("\(Self.tag) compareSingleSimilar. similarity \(similarity)")
            XCTAssertTrue(similarity > Self.threshold, "Face not matching: \(similarity)")
        }
    }
    
    func testCompareThreeSame() {
        bridge = useSDK {
            guard let face1 = Self.uiImage(named: "test_set_160/im_14"),
                  let face2 = Self.uiImage(named: "test_set_160/im_15"),
                  let face3 = Self.uiImage(named: "test_set_160/im_16") else {
                XCTFail("Failed to load images")
                return
            }

            let hash = $0.evaluate([face1, face2, face3])
            let similarity = $0.compare(images: [face3, face2, face1], withHash: hash)

            print("\(Self.tag) compareThreeSame. similarity \(similarity)")
            XCTAssertTrue(similarity > Self.threshold, "Face not matching: \(similarity)")
        }
    }
    
    func testCompareThreeSlightlySimilar() {
        bridge = useSDK {
            let groupA = ["test_set_160/im_14", "test_set_160/im_15", "test_set_160/im_16"]
            let groupB = ["test_set_160/im_1", "test_set_160/im_2", "test_set_160/im_5"]
            
            let groupAImages = groupA.compactMap { Self.uiImage(named: $0) }
            let groupBImages = groupB.compactMap { Self.uiImage(named: $0) }
            
            guard groupAImages.count == groupA.count, groupBImages.count == groupB.count else {
                XCTFail("Failed to load all images")
                return
            }

            let hash = $0.evaluate(groupAImages)
            let similarity = $0.compare(images: groupBImages, withHash: hash)

            print("\(Self.tag) compareThreeSlightlySimilar. similarity \(similarity)")
            XCTAssertTrue(similarity < Self.threshold, "Face matched: \(similarity)")
        }
    }
    
    func testCompareSingleDiff() {
        bridge = useSDK {
            guard let face1 = Self.uiImage(named: "test_set_160/im_4"),
                  let face2 = Self.uiImage(named: "test_set_160/im_15") else {
                XCTFail("Failed to load images")
                return
            }

            let hash = $0.evaluate([face2])
            let similarity = $0.compare(images: [face1], withHash: hash)

            print("\(Self.tag) compareSingleDiff. similarity \(similarity)")
            XCTAssertTrue(similarity < Self.threshold, "Faces matched: \(similarity)")
        }
    }
    
    func testCompareTwoDiff() {
        bridge = useSDK {
            let enrollFaces = ["test_set_160/im_14", "test_set_160/im_15"]
            let compareFaces = ["test_set_160/im_8", "test_set_160/im_9"]
            
            let enrollImages = enrollFaces.compactMap { Self.uiImage(named: $0) }
            let compareImages = compareFaces.compactMap { Self.uiImage(named: $0) }
            
            guard enrollImages.count == enrollFaces.count, compareImages.count == compareFaces.count else {
                XCTFail("Failed to load all images")
                return
            }

            let hash = $0.evaluate(enrollImages)
            let similarity = $0.compare(images: compareImages, withHash: hash)

            print("\(Self.tag) compareTwoDiff. similarity \(similarity)")
            XCTAssertTrue(similarity < Self.threshold, "Faces matched: \(similarity)")
        }
    }
    
    func testRun100EvalsAndComp() {
        bridge = useSDK { sdk in
            guard let face1 = Self.uiImage(named: "test_set_160/im_14"),
                  let face2 = Self.uiImage(named: "test_set_160/im_15"),
                  let face3 = Self.uiImage(named: "test_set_160/im_5"),
                  let face4 = Self.uiImage(named: "test_set_160/im_11") else {
                XCTFail("Failed to load images")
                return
            }

            let start = Self.currentTimeMillis
            for _ in 0..<100 {
                let hash = sdk.evaluate([face1, face2])
                _ = sdk.compare(images: [face3, face4], withHash: hash)
            }
            let duration = Self.currentTimeMillis - start
            print("\(Self.tag) run100. time \(Self.formatTimeWithMillis(duration))")
            XCTAssertTrue(true)
        }
    }
    
    func testUseEvaluateInitialized() {
        let sdk = PerchEyeSwift()
        
        guard let face = Self.uiImage(named: "test_set_160/im_14") else {
            XCTFail("Failed to load image")
            return
        }
        
        let hash = sdk.evaluate([face])
        _ = sdk.compare(images: [face], withHash: hash)
        sdk.destroy()
        XCTAssertTrue(true)
    }
    
    func testUseDestroyInitialized() {
        let sdk = PerchEyeSwift()
        sdk.destroy()
        XCTAssertTrue(true)
    }
    
    func testUseEmptyInputs() {
        bridge = useSDK {
            _ = $0.evaluate([])
            let similarity = $0.compare(images: [], withHash: "")
            print("\(Self.tag) useEmptyInputs. similarity \(similarity)")
            XCTAssertTrue(similarity < Self.threshold, "Faces matched unexpectedly: \(similarity)")
        }
    }
    
    func testUseRandomHash() {
        bridge = useSDK {
            guard let face = Self.uiImage(named: "test_set_160/im_14") else {
                XCTFail("Failed to load image")
                return
            }
            
            let similarity = $0.compare(images: [face], withHash: "sdjbshjd bsjh bdhjsb")
            print("\(Self.tag) useRandomHash. similarity \(similarity)")
            XCTAssertTrue(similarity < Self.threshold, "Faces matched unexpectedly: \(similarity)")
        }
    }
    
    // MARK: - Helper
    
    static var currentTimeMillis: Int64 { UnitTestsHelper.currentTimeMillis() }
    
    static let tag: String = "FACE_TEST"
    
    static let threshold: Float = 0.8
    
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
