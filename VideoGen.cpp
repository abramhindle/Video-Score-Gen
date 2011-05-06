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
    double hu[7];
    cv::HuMoments( mo, hu );
    
    printf("Hu: %f %f %f %f %f %f\n", hu[0], hu[1],hu[2],hu[3],hu[4],hu[5],hu[6]);
    //if ( (cvWaitKey(10) & 255) == 27 ) break;
    
    cvReleaseImage( &img);
  }
  //cvDestroyWindow( WINDOW );
  
  cvReleaseCapture(&capture);
  exit(0);
  return 0;
}

