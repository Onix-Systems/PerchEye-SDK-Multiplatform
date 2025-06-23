//
//  UnitTestsHelper.swift
//  perch-eye-iosTests
//
//  Created by Danil Chernikov on 05.06.2025.
//

import UIKit
@testable import PerchEyeFramework

class UnitTestsHelper {
    class func formatTimeWithMillis(_ millis: Int64) -> String {
        let minutes = (millis % 3_600_000) / 60_000
        let seconds = (millis % 60_000) / 1_000
        let ms = millis % 1_000
        
        return String(format: "%02d:%02d.%03d", minutes, seconds, ms)
    }
    
    class func currentTimeMillis() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    class func uiImage(named name: String) -> UIImage? {
        let test: Bundle = Bundle(for: UnitTestsHelper.self)
        guard let image = UIImage(named: name, in: test, compatibleWith: nil) else {
            return nil
        }
        
        return image
    }
}
