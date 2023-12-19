//
//  OpenCVWrapper.m
//  swiftCV2
//
//  Created by 정희원 on 2023/05/10.
//

#import "OpenCVWrapper.h"
#import <opencv2/opencv.hpp>
#import <opencv2/core.hpp>
#import <opencv2/objdetect/objdetect.hpp>
#import <opencv2/objdetect.hpp>
#import <TFLTensorFlowLite.h>


@implementation OpenCVWrapper

const char *face_cascade_name = [@"haarcascade_frontalface_alt.xml" cStringUsingEncoding:NSASCIIStringEncoding];
cv::CascadeClassifier cascadeClassifier;
bool cascade_loaded = false;
int INPUT_SIZE = 150;
float result[1][98];
double colorResult[6]; // s v r g b brow

+(UIImage *) recognizeImage:(UIImage *) source {
    // integrate tflite model
//    NSString* modelPath = [[NSBundle mainBundle] pathForResource:@"model" ofType:@"tflite"];
//    NSError *error;
//    TFLInterpreter *interpreter = [[TFLInterpreter alloc] initWithModelPath:modelPath error:&error];
//    if(error != NULL){
//        NSLog(@"Failed to load the model file");
//    }


    // 1. convert UIimage to Mat
    std::vector<cv::Rect> faceArray;
    CGImageRef image = CGImageCreateCopy(source.CGImage);
    CGFloat cols = CGImageGetWidth(image);
    CGFloat rows = CGImageGetHeight(image);
    cv::Mat mat_image(rows, cols, CV_8UC4);

    CGBitmapInfo bitmapFlags = kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault;
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = mat_image.step[0];
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image);

    CGContextRef context = CGBitmapContextCreate(mat_image.data, cols, rows, bitsPerComponent, bytesPerRow, colorSpace, bitmapFlags);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, cols, rows), image);
    CGContextRelease(context);
    cv::Mat grayImage;
    std::cout<<"mat size"<<mat_image.channels();

    // haarcascade에 넣기 위해 resize
    cvtColor( mat_image, grayImage, cv::COLOR_RGB2GRAY );
    //                        CV_RGBA2GRAY
    cv::Mat grayscaleImage, matImage;
    cv::resize(grayImage, grayscaleImage, cv::Size(0, 0), 0.5, 0.5);
    cv::resize(mat_image, matImage, cv::Size(0, 0), 0.5, 0.5);

    int height = grayscaleImage.rows;
    int width = grayscaleImage.cols;

    // Define minimum height of face in original frame below this height no face will detected
    int absoluteFaceSize = static_cast<int>(height * 0.1);


    //std::string face_cascade_name = "/Users/jungheewon/Desktop/iosApps/swiftCV2/swiftCV2/resources/haarcascade_frontalface_alt.xml";
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt" ofType:@"xml"];
    NSString* xmlPath = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt" ofType:@"xml"];
    const char* xmlPathCString = [xmlPath UTF8String];
    if(!cascade_loaded){
        std::cout<<face_cascade_name;
        if( !cascadeClassifier.load( xmlPathCString ) ){ printf("--(!)Error loading\n"); return source;};
        cascade_loaded = true;
    }

    cascadeClassifier.detectMultiScale(grayscaleImage, faceArray, 1.1, 2, 2,
                                       cv::Size(absoluteFaceSize, absoluteFaceSize), cv::Size());
    
    if (faceArray.size()<1){
        printf("no face detected");
        result[0][0] = -1;
    }

    for( size_t i = 0; i < faceArray.size(); i++ )
    {
        int x1 = (int)faceArray[i].tl().x;
        int y1 = (int)faceArray[i].tl().y;
        std::cout<<"start point"<<x1<<", "<<y1;

        int x2 = (int)faceArray[i].br().x;
        int y2 = (int)faceArray[i].br().y;
        std::cout<<"end point"<<x2<<", "<<y2;

        // For x1, y1
        if (x1 - 20 >= 0) {
            x1 = x1 - 20;
        }
        if (y1 - 20 >= 0) {
            y1 = y1 - 20;
        }

        // For x2, y2
        if (x2 + 20 <= width) {
            x2 = x2 + 20;
        }
        if (y2 + 20 <= height) {
            y2 = y2 + 20;
        }

        int w1 = x2 - x1;
        int h1 = y2 - y1;
        cv::Rect face_roi(x1, y1, w1, h1);

        // crop detected face area in original image
        cv::Mat cropped_rgba(matImage, face_roi);

        // Resize cropped_rgba to INPUT_SIZE x INPUT_SIZE
        cv::Mat resizeImage;
        cv::Mat cropped_rgba_;
        cv::resize(cropped_rgba, resizeImage, cv::Size(INPUT_SIZE, INPUT_SIZE), 0, 0, cv::INTER_CUBIC);
        cropped_rgba_ = resizeImage.clone();

        int c_height=cropped_rgba.rows;
        int c_width=cropped_rgba.cols;

        // input(cropped_rfga type Mat) to put in tensorflow lite model
        // 1. how to integrate tensorflow lite model in this objective c file, DONE
        // 2. what type of input it needs
        // 3. convert my cropped_rgba to that type.

        // make input type cropped rgba for interpreter
        NSMutableData *inputData = [[NSMutableData alloc] initWithCapacity:0];

        std::cout<<"cropped rgba"<<cropped_rgba_.rows<<" "<<cropped_rgba_.cols;


        for (int row = 0; row < cropped_rgba_.rows; row++) {
            for (int col = 0; col < cropped_rgba_.cols; col++) {
                cv::Vec4b intensity = cropped_rgba_.at<cv::Vec4b>(row, col);

                float red = (float)intensity.val[0]/255.0;
                float green = (float)intensity.val[1]/255.0;
                float blue = (float)intensity.val[2]/255.0;

                [inputData appendBytes:&red length:sizeof(red)];
                [inputData appendBytes:&green length:sizeof(green)];
                [inputData appendBytes:&blue length:sizeof(blue)];
            }
        }
        
        // Load the TensorFlow Lite model from a file
        NSError *error = nil;
        NSString* modelPath = [[NSBundle mainBundle] pathForResource:@"model48" ofType:@"tflite"];
        TFLInterpreterOptions* options = [TFLInterpreterOptions new];
        
        TFLInterpreter* interpreter = [[TFLInterpreter alloc] initWithModelPath:modelPath options:options error:&error];
        if (error != nil) {
            NSLog(@"Error initializing interpreter: %@", error.localizedDescription);
        }
        // Allocate memory for the model's input `TFLTensor`s.
        [interpreter allocateTensorsWithError:&error];
        if (error != nil) { NSLog(@"Error allocating mem: %@", error.localizedDescription);}

        // Set the input tensor data for the model
        TFLTensor* inputTensor = [interpreter inputTensorAtIndex:0 error:&error];
        Class inputClass = [inputTensor class];
        NSLog(@"Input tensor type: %lu", inputTensor.dataType);
        NSLog(@"Input tensor class: %@", inputClass);
        
        [inputTensor copyData:inputData error:&error];
        NSLog(@"Input tensor type: %lu", inputTensor.dataType);
        NSLog(@"Input tensor class: %@", inputClass);

        if (error != nil) { NSLog(@"Error copying data to input tensor: %@", error.localizedDescription); }

        // Run the model inference
        [interpreter invokeWithError:&error];
        if (error != nil) { std::cout<<"error\2\n";}

        // Get the output tensor data from the model
        TFLTensor* outputTensor = [interpreter outputTensorAtIndex:0 error:&error];
        if (error != nil) { NSLog(@"Error outputTensor: %@", error.localizedDescription);}
        
        // Copy output to `NSData` to process the inference results.
        NSData *outputData = [outputTensor dataWithError:&error];
        if (error != nil) { /* Error handling... */ }
        
        std::cout<<outputData.length<<"output\n";
    
        [outputData getBytes:result length:(sizeof(float) * 98)];
        
        float start_x = (result[0][52]+result[0][54])/2;
        float start_y = (result[0][53]+result[0][55])/2;
        float end_x = (result[0][64]+result[0][66])/2;
        float end_y = result[0][73];
        
        
        cv::Mat bgrImage;
        cv::cvtColor(cropped_rgba_, bgrImage, cv::COLOR_RGBA2BGR);
        // Convert the RGBA image to HSV color space
        cv::Mat hsvImage;
        cv::cvtColor(bgrImage, hsvImage, cv::COLOR_BGR2HSV);


        // Create a rectangular region of interest (ROI) for the circle
        cv::Rect r(start_x, start_y, end_x-start_x, end_y-start_y);
        cv::Mat circleRegion = hsvImage(r);

        // Calculate the average saturation and value within the circle
        cv::Scalar averageHSV = cv::mean(circleRegion, cv::noArray());

        double saturation = averageHSV.val[1];
        double value = averageHSV.val[2];
        
        colorResult[0] = saturation;
        colorResult[1] = value;
        
        cv::Scalar average = cv::mean(cropped_rgba);
        
        colorResult[2] = average.val[0];
        colorResult[3] = average.val[1];
        colorResult[4] = average.val[2];
        
        
        
        
        for (int j=0; j<98;j=j+2){
            float x_val = result[0][j];
            float y_val = result[0][j+1];
            
            cv::circle(resizeImage, cv::Point(x_val, y_val), 1, cv::Scalar(0, 255, 0, 255), -1);

        }
        
        cv::Size sz(c_width, c_height);
        cv::resize(resizeImage, cropped_rgba, sz, 0, 0, cv::INTER_CUBIC);
        
        cv::Mat roi(matImage, face_roi);
        cropped_rgba.copyTo(roi);

        float brow_l_x = result[0][26];
        float brow_r_x = result[0][28];
        float brow_l_y = result[0][27];
        float brow_r_y = result[0][29];
        
        cv::Vec3b rgbL = cropped_rgba_.at<cv::Vec3b>(brow_l_y, brow_l_x);
        cv::Vec3b rgbR = cropped_rgba_.at<cv::Vec3b>(brow_r_y, brow_r_x);
        
        double avgTone = (colorResult[2] + colorResult[2] + colorResult[2])/3;
        double avgBrow = (rgbL[0]+rgbL[1]+rgbL[2]+rgbR[0]+rgbR[1]+rgbR[2])/6;
        
        colorResult[5] = avgBrow/avgTone;
        
        
//        cv::Point center( faces[i].x + faces[i].width*0.5, faces[i].y + faces[i].height*0.5 );
//        ellipse( frame, center, cv::Size( faces[i].width*0.5, faces[i].height*0.5), 0, 0, 360, cv::Scalar( 0, 100, 255 ), 4, 8, 0 );
//
//        cv::Mat faceROI = frame_gray( faces[i] );


    }
    
    cv::resize(matImage,mat_image, cv::Size(0,0), 2, 2);
    //mat_image 를 UIImage 로

    ///1. Convert Mat to UIImage
    NSData *data = [NSData dataWithBytes:mat_image.data length:mat_image.elemSize() * mat_image.total()];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);

    bitmapFlags = kCGImageAlphaNone | kCGBitmapByteOrderDefault;
    bitsPerComponent = 8;
    bytesPerRow = mat_image.step[0];
    colorSpace = (mat_image.elemSize() == 1 ? CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB());

    image = CGImageCreate(mat_image.cols, mat_image.rows, bitsPerComponent, bitsPerComponent * mat_image.elemSize(), bytesPerRow, colorSpace, bitmapFlags, provider, NULL, false, kCGRenderingIntentDefault);
    UIImage *result = [UIImage imageWithCGImage:image];

    CGImageRelease(image);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);

    return result;
}

+(float *)getResult{
    float* array = new float[98];
    for(int i=0;i<98;i++){
        array[i] = result[0][i];
    }
    return array;
}

+(double *)getColorResult{
    double* array = new double[6];
    array[0] = colorResult[0];
    array[1] = colorResult[1];
    array[2] = colorResult[2];
    array[3] = colorResult[3];
    array[4] = colorResult[4];
    array[5] = colorResult[5];
    return array;
}

@end
