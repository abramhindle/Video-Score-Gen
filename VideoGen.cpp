#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <cv.h>
#include <highgui.h>
#include <vector>

#define WINDOW "mainWin"

using namespace cv;
using namespace std;


int main(int argc, char *argv[])
{
  int count = 0;
  
#ifdef GUI  
  cvNamedWindow(WINDOW, CV_WINDOW_AUTOSIZE); 
#endif
  CvCapture* capture = cvCaptureFromAVI("infile.avi");
  IplImage* imgI =0, *img = 0;   
  Mat lastGray ;
  imgI=cvQueryFrame( capture );
  Mat lastFrame(cvCloneImage(imgI));
  cv::cvtColor( lastFrame, lastGray, CV_BGR2GRAY, 1);
  

  printf("[\n");
  while( imgI=cvQueryFrame( capture )) {           // retrieve the captured frame

    int frameH    = (int) cvGetCaptureProperty(capture, CV_CAP_PROP_FRAME_HEIGHT);
    int frameW    = (int) cvGetCaptureProperty(capture, CV_CAP_PROP_FRAME_WIDTH);
    int fps       = (int) cvGetCaptureProperty(capture, CV_CAP_PROP_FPS);
    int numFrames = (int) cvGetCaptureProperty(capture,  CV_CAP_PROP_FRAME_COUNT);
    float posMsec   =       cvGetCaptureProperty(capture, CV_CAP_PROP_POS_MSEC);
    int posFrames   = (int) cvGetCaptureProperty(capture, CV_CAP_PROP_POS_FRAMES);
    float posRatio  =       cvGetCaptureProperty(capture, CV_CAP_PROP_POS_AVI_RATIO);
    img = cvCloneImage(imgI);
    
    
    const char * startStr = (count==0)?"":",\n";
    printf("%s{ \"type\":\"frame\", \"frame\":%d, \"channels\":%d, \"BPP\":%d, \"W\":%d, \"H\":%d, \"WS\":%d,\n", 
           startStr,
           count,
           imgI->nChannels,
           imgI->depth,
           imgI->width,
           imgI->height,
           imgI->widthStep);
#ifdef GUI
    cvShowImage(WINDOW, img );
#endif    
    //IplImage *dst = cvCreateImage( cvSize( img->width, img->height ), IPL_DEPTH_8U, 1 );    
    /* CV_RGB2GRAY: convert RGB image to grayscale */
    
    Mat mtx( img );

    Mat gray;//( img->width, img->height, CV_8U);
    //cvtColor( img, mtx, CV_RGB2GRAY );
    cv::cvtColor( mtx, gray, CV_BGR2GRAY, 1);

    Scalar mean;
    Scalar stddev;
    meanStdDev(gray, mean, stddev);
    printf("\t\"mean\":%e, \"std\":%e,\n",mean[0],stddev[0]);


    Moments mo = cv::moments( gray );
    // spatial moments
    //double m00, m10, m01, m20, m11, m02, m30, m21, m12, m03;
    // central moments
    //double mu20, mu11, mu02, mu30, mu21, mu12, mu03;

    printf("\t\"spacial-moments\":[%f,%f,%f,%f,%f,%f,%f,%f,%f,%f],\n",
           mo.m00, mo.m10, mo.m01, mo.m20, mo.m11, mo.m02, mo.m30, mo.m21, mo.m12, mo.m03);
    printf("\t\"central-moments\":[%f,%f,%f,%f,%f,%f,%f],\n", mo.mu20, mo.mu11, mo.mu02, mo.mu30, mo.mu21, mo.mu12, mo.mu03);

    double hu[7];
    cv::HuMoments( mo, hu );
    
    printf("\t\"hu\":[%f,%f,%f,%f,%f,%f],\n", hu[0], hu[1],hu[2],hu[3],hu[4],hu[5],hu[6]);
    //if ( (cvWaitKey(10) & 255) == 27 ) break;

    const char * redStr = "red";
    const char * greenStr = "green";
    const char * blueStr = "blue";
    const char * colorNames[] = { redStr, greenStr, blueStr };
    vector<Mat> cChannels;
    split( mtx, cChannels);
    for (int i = 0; i < 3; i++) {
      Mat hist;
      const char * name = colorNames[ i ];
      const int hSize = 8;
      const int arr[] = { hSize };
      const int * histSize = arr;
      // 255 (pure spectrum color)
      const float srangesf[] = {0,256};
      const float * sranges[] = {srangesf};
      const int channelsi = 0;
      const int * channels = &channelsi;
      const Mat m[] = { cChannels[i] };
      const Mat mask;
      cv::calcHist( m, 1, &channelsi, mask,//do not use mask
                    hist, 1, (const int*)histSize, (const float **)sranges,
                true, // the histogram is uniform
                false );
      printf("\t\t\"%s-hist\":[\n\t\t\t",name);
      for( int h = 0; h < hSize; h++ ) {
        float binVal = hist.at<float>(h, 0);
        printf("%s%e",((h==0)?"":","),binVal);
      }
      printf("],\n");
    }


    //SIFT
    std::vector<char *> descv;
    descv.push_back("SIFT");
    descv.push_back("SURF");
    for (int desci = 0; desci < descv.size(); desci++) {
      if (desci!=0) {
        printf(",\n");
      }
      char * descname = descv[desci];
      Ptr<FeatureDetector> fd = FeatureDetector::create( "SURF" );   
      vector <KeyPoint> keypoints;
      fd->detect( gray, keypoints );
      Ptr<DescriptorExtractor> dc = DescriptorExtractor::create( "SURF" );
      Mat descriptors;
      dc->compute( gray , keypoints, descriptors );
      // now we have keypoints in a vector and the descriptors!
      printf("\t\"%s\":{\n",descname);
      printf("\t\t\"nkeypoints\":%zd\n", keypoints.size());
      /*
        printf(",");
      printf("\t\t\"keypoints\":[\n");
      for (int i = 0 ; i < keypoints.size(); i++ ) {
        KeyPoint k = keypoints[i];    
        if (i != 0) {
          printf(",\n");
        }
        printf("\t\t\t{\"x\":%e,\"y\":%e,\"size\":%e,\"angle\":%e,\"response\":%e,\n",k.pt.x,k.pt.y,k.size,k.angle,k.response);
        printf("\t\t\t\t\"descriptor\":[\n");
        if (descriptors.cols >= 1) {
          printf("%e",descriptors.at<double>(0,i));
        }
        for (int j = 1; j < descriptors.cols ; j++) {
          printf(",%e",descriptors.at<double>(j,i));
        }
        printf("]\n");
        printf("}\n");
      }
      printf("]");
      */
      printf("}\n");
    }

    printf(",\n");

    Mat diff;
    absdiff(gray,lastGray,diff);
    meanStdDev(diff, mean, stddev);
    printf("\t\"meandiff\":%e, \"stddiff\":%e\n",mean[0],stddev[0]);

    //printf("]\n");
    //printf("}\n");
    printf("}\n");
    gray.copyTo(lastGray);
    mtx.copyTo(lastFrame);
    cvReleaseImage( &img);
#ifdef GUI
    if ( (cvWaitKey(1) & 255) == 27 ) break;
#endif
    count++;
  }
  printf("]\n");
#ifdef GUI
  cvDestroyWindow( WINDOW );
#endif  
  cvReleaseCapture(&capture);
  exit(0);
  return 0;
}

