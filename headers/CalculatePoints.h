//
//  CalculatePoints.h
//  swiftCV2
//
//  Created by 정희원 on 2023/05/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalculatePoints : NSObject{
    double resultReshaped[49][2];
    
    double forehead[2];
    double left_eyebrow[2];
    double right_eyebrow[2];
    double left_eye[6][2];
    double right_eye[6][2];
    double nose[3][2];
    double lip[6][2];
    double chin[2];
    double left_side[2][2];
    double right_side[2][2];
    
    double height;
    double width;
    double left_width;
    double right_width;
    
    double left_eye_width;
    double right_eye_width;
    double left_eye_height;
    double right_eye_height;
    
    double middle;
    double middle_left;
    double middle_right;
    
    double node_width;
    
    double lip_width;
    double upper_lip;
    double lower_lip;
    double lip_height;
    
    double forehead_to_eyebrow;
    
    double eyebrow_to_nose;
    double nose_to_chin;
    
    double eyebrow_to_eye;
    double left_eyebrow_to_eye;
    double right_eyebrow_to_eye;
    
    double nose_to_eye;
    double nose_to_lip;
    double chin_to_lip;
    
    double nose_width;
    
    double** centerVerLine;
    double** centerHorEyeLine;
    double** centerHorLipLine;
}

// 함수 이름
- (void)calculate;
- (id)initWithInput:(float *)result;

- (double*)getWidthHeight;
- (double*)getThreePart;
- (double*)getMiddleEyeWidth;

- (double*)getEyeWidthHeight;
- (double*)getEyeEyebrowHeight;
- (double*)getMiddleNoseLipWidth;

- (double*)getEyePos;
- (double*)getLipPos;
- (double*)getLipWidthHeight;
- (double*)getLineCurve;

@end

NS_ASSUME_NONNULL_END
