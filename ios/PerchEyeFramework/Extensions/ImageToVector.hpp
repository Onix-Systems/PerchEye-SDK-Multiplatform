//
//  ImageToVector.hpp
//  perch-eye-ios
//
//  Created by Sergey Pritula on 26.05.2025.
//

#import <Foundation/Foundation.h>
#import <UIKit//UIKit.h>
#import <vector>

NS_ASSUME_NONNULL_BEGIN

@interface ImageToVector: NSObject

+ (std::vector<uint8_t>)UIImageToByteVector:(UIImage *)image width:(int&)width height:(int&)height;

@end

NS_ASSUME_NONNULL_END
