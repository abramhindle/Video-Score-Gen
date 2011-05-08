#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <cv.h>
#include <highgui.h>

#define WINDOW "mainWin"

using namespace cv;
using namespace std;


int main(int argc, char *argv[])
{
  int count = 0;
  
  //cvNamedWindow(WINDOW, CV_WINDOW_AUTOSIZE); 

  CvCapture* capture = cvCaptureFromAVI("infile.avi");
  IplImage* imgI =0, *img = 0; 
  
  while( imgI=cvQueryFrame( capture )) {           // retrieve the captured frame

    int frameH    = (int) cvGetCaptureProperty(capture, CV_CAP_PROP_FRAME_HEIGHT);
    int frameW    = (int) cvGetCaptureProperty(capture, CV_CAP_PROP_FRAME_WIDTH);
    int fps       = (int) cvGetCaptureProperty(capture, CV_CAP_PROP_FPS);
    int numFrames = (int) cvGetCaptureProperty(capture,  CV_CAP_PROP_FRAME_COUNT);
    float posMsec   =       cvGetCaptureProperty(capture, CV_CAP_PROP_POS_MSEC);
    int posFrames   = (int) cvGetCaptureProperty(capture, CV_CAP_PROP_POS_FRAMES);
    float posRatio  =       cvGetCaptureProperty(capture, CV_CAP_PROP_POS_AVI_RATIO);

    img = cvCloneImage(imgI);
    printf("Frame %d Channels:%d BPP:[%d] WxH:%dx%d WS:%d\n", 
           count++,
           imgI->nChannels,
           imgI->depth,
           imgI->width,
           imgI->height,
           imgI->widthStep);
    //cvShowImage(WINDOW, img );
    
    //IplImage *dst = cvCreateImage( cvSize( img->width, img->height ), IPL_DEPTH_8U, 1 );    
    /* CV_RGB2GRAY: convert RGB image to grayscale */
    
    Mat mtx( img );
    Mat gray;//( img->width, img->height, CV_8U);
    //cvtColor( img, mtx, CV_RGB2GRAY );
    cv::cvtColor( mtx, gray, CV_BGR2GRAY, 1);
    Moments mo = cv::moments( gray );
    // spatial moments
    //double m00, m10, m01, m20, m11, m02, m30, m21, m12, m03;
    // central moments
    //double mu20, mu11, mu02, mu30, mu21, mu12, mu03;

    printf("\tSpacial Moments: %f %f %f %f %f %f %f %f %f %f\n",
           mo.m00, mo.m10, mo.m01, mo.m20, mo.m11, mo.m02, mo.m30, mo.m21, mo.m12, mo.m03);
    printf("\tCentral Moments: %f %f %f %f %f %f %f\n", mo.mu20, mo.mu11, mo.mu02, mo.mu30, mo.mu21, mo.mu12, mo.mu03);

    double hu[7];
    cv::HuMoments( mo, hu );
    
    printf("\tHu: %f %f %f %f %f %f\n", hu[0], hu[1],hu[2],hu[3],hu[4],hu[5],hu[6]);
    //if ( (cvWaitKey(10) & 255) == 27 ) break;

    //SIFT

    Ptr<DescriptorExtractor> dc = DescriptorExtractor::create( "SIFT" );
    vector <KeyPoint> keypoints;
    Mat descriptors;
    (*dc).compute( gray , keypoints, descriptors );
    // now we have keypoints in a vector and the descriptors!
    printf("\tSIFT:\n");
    printf("\t\tKeypoints: %d\n", keypoints.size());
    for (int i = 0 ; i < keypoints.size(); i++ ) {
      KeyPoint k = keypoints[i];      
      printf("\t\t\tKeypoint: %f %f %f\n",k.pt.x,k.pt.y,k.size,k.angle,k.response);
      printf("\t\t\t\tSIFT-Descriptor: ");
      for (int j = 0; j < descriptors.cols ; j++) {
        printf("\t%f",descriptors.at<double>(i,j));
      }
      printf("\n");
    }
      
    
    cvReleaseImage( &img);
  }
  //cvDestroyWindow( WINDOW );
  
  cvReleaseCapture(&capture);
  exit(0);
  return 0;
}

