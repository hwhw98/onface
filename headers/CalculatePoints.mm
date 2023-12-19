//
//  CalculatePoints.m
//  swiftCV2
//
//  Created by 정희원 on 2023/05/13.
//

#import "CalculatePoints.h"
#import "OpenCVWrapper.h"
#import <opencv2/opencv.hpp>
#import <opencv2/core.hpp>
#import <opencv2/objdetect/objdetect.hpp>
#import <opencv2/objdetect.hpp>

@implementation CalculatePoints

// 생성자
- (id)initWithInput:(float *)input{
    self = [super init];
    if(self!=nil){
        for (int i = 0; i < 49; i++) {
            for (int j = 0; j < 2; j++) {
                resultReshaped[i][j] = (double)input[i*2+j];
            }
        }
    
        for (int i=0;i<2;i++){
            forehead[i] = resultReshaped[48][i];
            left_eyebrow[i] = resultReshaped[13][i];
            right_eyebrow[i] = resultReshaped[14][i];
    
            nose[0][i] = resultReshaped[17][i];
            nose[1][i] = resultReshaped[19][i];
            nose[2][i] = resultReshaped[21][i];
    
            left_eye[0][i] = resultReshaped[22][i];
            left_eye[1][i] = resultReshaped[23][i];
            left_eye[2][i] = resultReshaped[24][i];
            left_eye[3][i] = resultReshaped[25][i];
            left_eye[4][i] = resultReshaped[26][i];
            left_eye[5][i] = resultReshaped[27][i];
    
            right_eye[0][i] = resultReshaped[28][i];
            right_eye[1][i] = resultReshaped[29][i];
            right_eye[2][i] = resultReshaped[30][i];
            right_eye[3][i] = resultReshaped[31][i];
            right_eye[4][i] = resultReshaped[32][i];
            right_eye[5][i] = resultReshaped[33][i];
    
            lip[0][i] = resultReshaped[34][i];
            lip[1][i] = resultReshaped[36][i];
            lip[2][i] = resultReshaped[38][i];
            lip[3][i] = resultReshaped[40][i];
            lip[4][i] = resultReshaped[46][i];
            lip[5][i] = resultReshaped[43][i];
    
            chin[i] = resultReshaped[5][i];
    
            left_side[0][i] = resultReshaped[0][i];
            left_side[1][i] = resultReshaped[1][i];
    
            right_side[0][i] = resultReshaped[9][i];
            right_side[1][i] = resultReshaped[10][i];
        }
        std::vector<cv::Point> contour1 = {cv::Point(forehead[0], forehead[1]), cv::Point(nose[1][0], nose[1][1]), cv::Point(chin[0], chin[1])};
        centerVerLine = findLineOnPoints(contour1);
        
        std::vector<cv::Point> contour2 = {cv::Point(left_eye[0][0], left_eye[0][1]),  cv::Point(left_eye[3][0], left_eye[3][1]), cv::Point(right_eye[0][0], right_eye[0][1]),  cv::Point(right_eye[3][0], right_eye[3][1])};
        centerHorEyeLine = findLineOnPoints(contour2);
        
        std::vector<cv::Point> contour3 = {cv::Point(lip[0][0], lip[0][1]), cv::Point(lip[2][0], lip[2][1])};
        centerHorLipLine = findLineOnPoints(contour3);
        
    }
    return self;
}

- (double*)getWidthHeight {
    double* array = new double[2];
    array[0] = width;
    array[1] = height;
    return array;
}

- (double*)getThreePart{
    double* array = new double[3];
    array[0] = forehead_to_eyebrow;
    array[1] = eyebrow_to_nose;
    array[2] = nose_to_chin;
    return array;
}
- (double*)getMiddleEyeWidth{
    double* array = new double[6];
    array[0] = left_eye_width;
    array[1] = right_eye_width;
    array[2] = middle_left;
    array[3] = middle_right;
    array[4] = left_width;
    array[5] = right_width;
    return array;
}

- (double*)getEyeWidthHeight{
    double* array = new double[4];
    array[0] = left_eye_width;
    array[1] = right_eye_width;
    array[2] = left_eye_height;
    array[3] = right_eye_height;
    return array;
}
- (double*)getEyeEyebrowHeight{
    double* array = new double[4];
    array[0] = left_eyebrow_to_eye;
    array[1] = right_eyebrow_to_eye;
    array[2] = left_eye_height;
    array[3] = right_eye_height;
    return array;
}
- (double*)getMiddleNoseLipWidth{
    double* array = new double[3];
    array[0] = middle;
    array[1] = nose_width;
    array[2] = lip_width;
    return array;
}

- (double*)getEyePos{
    double* array = new double[2];
    array[0] = eyebrow_to_eye;
    array[1] = nose_to_eye;
    return array;
}
- (double*)getLipPos{
    double* array = new double[2];
    array[0] = nose_to_lip;
    array[1] = chin_to_lip;
    return array;
}
- (double*)getLipWidthHeight{
    double* array = new double[4];
    array[0] = upper_lip;
    array[1] = lower_lip;
    array[2] = lip_width;
    array[3] = lip_height;
    return array;
}

- (double*)getLineCurve{
    double* array = new double[3];
    array[0] = height/width;
    array[1] = eyebrow_to_nose/nose_to_chin;
    array[2] = (left_eye_width/left_eye_height + right_eye_height/right_eye_width)/2;
    return array;
}



- (void)calculate{
    
    std::vector<cv::Vec2d> points;
    
    
    // 가로 구하기
    points.push_back(cv::Vec2d(left_side[0][0], left_side[0][1]));
    points.push_back(cv::Vec2d(left_side[1][0], left_side[1][1]));
    double result_l = maxDistancePointLine(points, centerVerLine);
    points.clear();
   
    points.push_back(cv::Vec2d(right_side[0][0], right_side[0][1]));
    points.push_back(cv::Vec2d(right_side[1][0], right_side[1][1]));
    double result_r = maxDistancePointLine(points, centerVerLine);
    points.clear();
    
    left_width = result_l;
    right_width = result_r;
    width = result_l + result_r;
    
    
    // 세로 구하기
    points.push_back(cv::Vec2d(forehead[0], forehead[1]));
    double result_u = maxDistancePointLine(points, centerHorEyeLine);
    points.clear();
    
    points.push_back(cv::Vec2d(chin[0], chin[1]));
    double result_d = maxDistancePointLine(points, centerHorEyeLine);
    points.clear();
    
    height = result_u + result_d;
    
    
    //이마 눈썹 거리
    points.push_back(cv::Vec2d(forehead[0], forehead[1]));
    result_u = maxDistancePointLine(points, centerHorEyeLine);
    points.clear();
    
    points.push_back(cv::Vec2d(left_eyebrow[0], left_eyebrow[1]));
    points.push_back(cv::Vec2d(right_eyebrow[0], right_eyebrow[1]));
    result_d = maxDistancePointLine(points, centerHorEyeLine);
    points.clear();
    
    forehead_to_eyebrow = result_u - result_d;
    
    
    //눈썹 코 거리
    points.push_back(cv::Vec2d(nose[1][0], nose[1][1]));
    result_u = maxDistancePointLine(points, centerHorEyeLine);
    
    eyebrow_to_nose = result_d + result_u;
    
    
    //코 턱 거리
    result_u = maxDistancePointLine(points, centerHorLipLine);
    points.clear();
    
    points.push_back(cv::Vec2d(chin[0], chin[1]));
    result_d = maxDistancePointLine(points, centerHorLipLine);
    points.clear();
    
    nose_to_chin = result_u + result_d;
    
    
    //미간 너비
    points.push_back(cv::Vec2d(left_eye[3][0], left_eye[3][1]));
    result_l = maxDistancePointLine(points, centerVerLine);
    points.clear();
    
    points.push_back(cv::Vec2d(right_eye[0][0], right_eye[0][1]));
    result_r = maxDistancePointLine(points, centerVerLine);
    points.clear();
    
    middle_left = result_l;
    middle_right = result_r;
    middle = result_l + result_r;
    
    
    //왼쪽 오른쪽 눈 너비
        //바깥
    points.push_back(cv::Vec2d(left_eye[0][0], left_eye[0][1]));
    result_l = maxDistancePointLine(points, centerVerLine);
    points.clear();
    
    points.push_back(cv::Vec2d(right_eye[3][0], right_eye[3][1]));
    result_r = maxDistancePointLine(points, centerVerLine);
    points.clear();
        //미간이랑 계산
    left_eye_width = result_l - middle_left;
    right_eye_width = result_d - middle_right;
    
    
    //왼쪽 눈 높이
    points.push_back(cv::Vec2d(left_eye[1][0], left_eye[1][1]));
    points.push_back(cv::Vec2d(left_eye[2][0], left_eye[2][1]));
    result_u = maxDistancePointLine(points, centerHorEyeLine);
    points.clear();
    
    points.push_back(cv::Vec2d(left_eye[4][0], left_eye[4][1]));
    points.push_back(cv::Vec2d(left_eye[5][0], left_eye[5][1]));
    result_d = maxDistancePointLine(points, centerHorEyeLine);
    points.clear();
    
    left_eye_height = result_u + result_d;
    
    
    //오른쪽 눈 높이
    points.push_back(cv::Vec2d(right_eye[1][0], right_eye[1][1]));
    points.push_back(cv::Vec2d(right_eye[2][0], right_eye[2][1]));
    result_u = maxDistancePointLine(points, centerHorEyeLine);
    points.clear();
    
    points.push_back(cv::Vec2d(right_eye[4][0], right_eye[4][1]));
    points.push_back(cv::Vec2d(right_eye[5][0], right_eye[5][1]));
    result_d = maxDistancePointLine(points, centerHorEyeLine);
    points.clear();
    
    right_eye_height = result_u + result_d;
    
    
    //눈썹과 눈가로선 거리
    points.push_back(cv::Vec2d(left_eyebrow[0], left_eyebrow[1]));
    result_l = maxDistancePointLine(points, centerHorEyeLine);
    points.clear();
    
    points.push_back(cv::Vec2d(right_eyebrow[0], right_eyebrow[1]));
    result_r = maxDistancePointLine(points, centerHorEyeLine);
    points.clear();
    
    eyebrow_to_eye = (result_l + result_r)/2;
    
    
    //코와 눈 가로선 거리
    points.push_back(cv::Vec2d(nose[1][0], nose[1][1]));
    nose_to_eye = maxDistancePointLine(points, centerHorEyeLine);
    points.clear();
    
    
    //눈썹 눈 사이거리
    points.push_back(cv::Vec2d(left_eyebrow[0], left_eyebrow[1]));
    result_u = maxDistancePointLine(points, centerHorEyeLine);
    points.clear();
    
    points.push_back(cv::Vec2d(left_eye[1][0], left_eye[1][1]));
    points.push_back(cv::Vec2d(left_eye[2][0], left_eye[2][1]));
    result_d = maxDistancePointLine(points, centerHorEyeLine);
    points.clear();
    
    left_eyebrow_to_eye = result_u - result_d;
    
    points.push_back(cv::Vec2d(right_eyebrow[0], right_eyebrow[1]));
    result_u = maxDistancePointLine(points, centerHorEyeLine);
    points.clear();
    
    points.push_back(cv::Vec2d(right_eye[1][0], right_eye[1][1]));
    points.push_back(cv::Vec2d(right_eye[2][0], right_eye[2][1]));
    result_d = maxDistancePointLine(points, centerHorEyeLine);
    points.clear();
    
    right_eyebrow_to_eye = result_u - result_d;
    
    
    // 코 폭
    points.push_back(cv::Vec2d(nose[0][0], nose[0][1]));
    result_l = maxDistancePointLine(points, centerVerLine);
    points.clear();
    
    points.push_back(cv::Vec2d(nose[2][0], nose[2][1]));
    result_r = maxDistancePointLine(points, centerVerLine);
    points.clear();
    
    nose_width = result_l + result_r;
    
    
    //입에서 코 거리
    points.push_back(cv::Vec2d(nose[1][0], nose[1][1]));
    nose_to_lip = maxDistancePointLine(points, centerHorLipLine);
    points.clear();
    
    
    //입에서 턱
    points.push_back(cv::Vec2d(chin[0], chin[1]));
    chin_to_lip = maxDistancePointLine(points, centerHorLipLine);
    points.clear();
    
    
    //입술 가로 폭
    points.push_back(cv::Vec2d(lip[0][0], lip[0][1]));
    result_l = maxDistancePointLine(points, centerVerLine);
    points.clear();
    
    points.push_back(cv::Vec2d(lip[2][0], lip[2][1]));
    result_r = maxDistancePointLine(points, centerVerLine);
    points.clear();
    
    lip_width = result_l + result_r;
    
    
    //윗입술, 아래입술, 입술세로폭
    points.push_back(cv::Vec2d(lip[1][0], lip[1][1]));
    result_u = maxDistancePointLine(points, centerHorLipLine);
    points.clear();
    
    points.push_back(cv::Vec2d(lip[3][0], lip[3][1]));
    result_d = maxDistancePointLine(points, centerHorLipLine);
    points.clear();
    
    upper_lip = result_u;
    lower_lip = result_d;
    lip_height = result_u + result_d;
    
    delete centerVerLine;
    delete centerHorEyeLine;
    delete centerHorLipLine;
}



double** findLineOnPoints(std::vector<cv::Point>& contour) {
    std::vector<cv::Point2f> contour2f(contour.begin(), contour.end());
    cv::Mat line;
    cv::fitLine(contour2f, line, cv::DIST_L2, 0.0, 0.01, 0.01);

    // Extract the line parameters
    double vx = line.at<float>(0, 0);
    double vy = line.at<float>(1, 0);
    double x = line.at<float>(2, 0);
    double y = line.at<float>(3, 0);

    // Calculate the endpoints of the line
    double lefty = (-x * vy / vx + y);
    double righty = ((150 - x) * vy / vx + y);
    cv::Point2d point1(150 - 1, righty);
    cv::Point2d point2(0, lefty);

    double** points = new double*[2];
    points[0] = new double[2];
    points[0][0] = point1.x;
    points[0][1] = point1.y;
    points[1] = new double[2];
    points[1][0] = point2.x;
    points[1][1] = point2.y;

    return points;
}



double maxDistancePointLine(std::vector<cv::Vec2d>& points, double** line) {
    double x1 = line[0][0];
    double y1 = line[0][1];
    double x2 = line[1][0];
    double y2 = line[1][1];

    double maxDistance = 0;
    cv::Vec2d closestPoint;

    for (const auto& point : points) {
        double x0 = point[0];
        double y0 = point[1];
        
        double distance = std::abs((y2 - y1) * x0 - (x2 - x1) * y0 + x2 * y1 - y2 * x1) /
        std::sqrt(std::pow(y2 - y1, 2) + std::pow(x2 - x1, 2));
        
        if (distance > maxDistance) {
            maxDistance = distance;
            closestPoint = cv::Vec2d(x0, y0);
            
        }
    }
    
//    double result = new double[3];
//    result[0] = closestPoint[0];
//    result[1] = closestPoint[1];
//    result[2] = maxDistance;

    return maxDistance;
}




// class 내 함수들
// find line on points


// points line 사이 거리(최대)



// point line 사이 거리(최소)




//- (double**)findLineOnPoints:(double**)points count:(int)count {
//    // Convert points to a cv::Mat
//    cv::Mat pointsMat(count, 2, CV_64F);
//    for (int i = 0; i < count; i++) {
//        pointsMat.at<double>(i, 0) = points[i][0];
//        pointsMat.at<double>(i, 1) = points[i][1];
//    }
//
//    // Fit a line to the points
//    cv::Mat line;
//    cv::fitLine(pointsMat, line, cv::DIST_L2, 0.0, 0.01, 0.01);
//
//    // Extract the line parameters
//    double vx = line.at<double>(0, 0);
//    double vy = line.at<double>(1, 0);
//    double x = line.at<double>(2, 0);
//    double y = line.at<double>(3, 0);
//
//    // Calculate the endpoints of the line
//    double lefty = (-x * vy / vx + y);
//    double righty = ((cols - x) * vy / vx + y);
//
//    // Create a 2D array to hold the endpoints
//    double** result = new double*[2]{
//        new double[2] {static_cast<double>(cols - 1), righty},
//        new double[2] {0, lefty}
//    };
//
//    return result;
//}
//std::vector<double> max_distance_point_line(std::vector<std::vector<double>> points, std::vector<std::vector<double>> line){
//    double x1 = line[0][0];
//    double y1 = line[0][1];
//    double x2 = line[1][0];
//    double y2 = line[1][1];
//
//    double maxDistance = 0;
//    std::vector<double> closestPoint(2);
//
//    for (auto point : points) {
//        double x0 = point[0];
//        double y0 = point[1];
//
//        double distance = std::abs((y2-y1)*x0 - (x2-x1)*y0 + x2*y1 - y2*x1) /
//                std::sqrt(std::pow(y2-y1, 2) + std::pow(x2-x1, 2));
//
//        if (distance > maxDistance) {
//            maxDistance = distance;
//            closestPoint[0] = x0;
//            closestPoint[1] = y0;
//        }
//    }
//
//    return {closestPoint[0], closestPoint[1], maxDistance};
//}
//
//+ (double)min_distance_point_line2:(double*)point line:(double**)line {
//    double x1 = line[0][0];
//    double y1 = line[0][1];
//    double x2 = line[1][0];
//    double y2 = line[1][1];
//
//    double minDistance = DBL_MAX;
//    double closestPoint[2];
//
//    double x0 = point[0];
//    double y0 = point[1];
//
//    double distance = fabs((y2-y1)*x0 - (x2-x1)*y0 + x2*y1 - y2*x1) /
//                    sqrt(pow(y2-y1, 2) + pow(x2-x1, 2));
//
//    if (distance < minDistance) {
//        minDistance = distance;
//        closestPoint[0] = x0;
//        closestPoint[1] = y0;
//    }
//
//    return minDistance;
//}



@end
