//
//  OpenCVWrapper.h
//  swiftCV2
//
//  Created by 정희원 on 2023/05/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+(UIImage *)recognizeImage:(UIImage *)source;

+(float *)getResult;

+(double *)getColorResult;

@end

NS_ASSUME_NONNULL_END
