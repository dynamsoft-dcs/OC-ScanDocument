//
//  ViewController.m
//  AdvancedDocumentProcessDemo
//
//  Created by Dynamsoft on 8/22/17.
//  Copyright © 2017 Dynamsoft. All rights reserved.
//

#import "ViewController.h"

#import <DynamsoftCameraSDK/DcsView.h>
#import <DynamsoftCameraSDK/DcsUIImageGalleryView.h>
#import <DynamsoftCameraSDK/DcsUIVideoView.h>
#import <DynamsoftCameraSDK/DcsUIDocumentEditorView.h>
#define SZ_BUTTON_HEIGHT 84
#define SZ_BUTTON_WIDTH  84

@interface ViewController ()<DcsUIVideoViewDelegate ,DcsUIDocumentEditorViewDelegate, DcsUIImageGalleryViewDelegate>{
    DcsView *dcsView;
    UIButton *openVideoViewButton;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ///////////////////add navigationbar////////////////////////
    UINavigationBar *navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    UINavigationItem *titleItem = [[UINavigationItem alloc]initWithTitle:@"ScanDocument"];
    [navigationBar pushNavigationItem:titleItem animated:YES];
    [self.view addSubview:navigationBar];
    ///////////////////set the log level//////////////////
	[DcsView setLogLevel:DLLE_DEBUG];
    ///////////////////add DcsView////////////////////////
    dcsView = [[DcsView alloc]initWithFrame:CGRectMake(0, navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-navigationBar.frame.size.height)];
    //Show the imageGalleryView when DcsView loaded
    dcsView.currentView = DVE_IMAGEGALLERYVIEW;
    dcsView.imageGalleryView.delegate = self;
    ////////////videoview setting////////////////////////////
    dcsView.videoView.mode=DME_DOCUMENT;
    dcsView.videoView.nextViewAfterCapture= DVE_EDITORVIEW;
    dcsView.videoView.delegate = self;
    ////////////DocumentEditView setting////////////////////
    dcsView.documentEditorView.nextViewAfterOK     = DVE_IMAGEGALLERYVIEW;
    dcsView.documentEditorView.nextViewAfterCancel = DVE_VIDEOVIEW;
    dcsView.documentEditorView.delegate = self;
    [self.view addSubview:dcsView];
    
    ///////////////////add an open videoView button////////////////////////
    openVideoViewButton = [self CreateOpenVideoButton:CGRectMake((self.view.frame.size.width-84)/2, self.view.frame.size.height-175, 84, 84)];
    [openVideoViewButton addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    [dcsView.imageGalleryView addSubview:openVideoViewButton];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////////////////
//UIVideoView delegate implement
- (BOOL) onPreCapture:(id)sender{
    //if you return NO,the capture will be canncelled.
    NSLog(@"PreCapture invoked");
    return YES;
}
- (void) onPostCapture:(id)sender image:(DcsImage *)image{
    NSLog(@"PostCapture invoked");
}

- (void) onCaptureTapped:(id)sender{
    NSLog(@"Capture tap invoked");
}

- (void) onCancelTapped:(id)sender{
    if([sender isMemberOfClass:[DcsUIVideoView class]])
        NSLog(@"video view cancel tap invoked");
    if([sender isMemberOfClass:[DcsUIDocumentEditorView class]])
        NSLog(@"DocumentEditorView cancel tap invoked");
}

- (void) onCaptureFailure:(id)sender exception:(DcsException *)exception{
    NSLog(@"CaptureFailure  invoked");
    
}
- (void) onDocumentDetected:(id)sender document:(DcsDocument *)document{
    
}
//documentEditorView delegate implement
- (void) onOkTapped:(id)sender exception:(DcsException *)exception{
    NSLog(@"OkTap invoked");
}
////////////////////////////////////////////////////
// imageGalleryview delegate implement
- (void) onSingleTap:(id)sender index:(NSInteger)index{
    NSLog(@"SingleTap  invoked");
}
- (void)onSelectChanged:(id) sender selectedIndices:(NSArray *)indices{
    NSLog(@"SelectChanged  invoked");
}
- (void)onLongPress:(id)sender index:(NSInteger)index{
    NSLog(@"LongPress  invoked");
}
- (void) onClick{
    dcsView.currentView = DVE_VIDEOVIEW;
}
- (UIButton *) CreateOpenVideoButton:(CGRect)imageFrame{
    UIButton *imageButton = [[UIButton alloc]initWithFrame:imageFrame];
    UIImage *normalImg = [UIImage imageNamed:@"icon_camera"];
    UIImage *selectedImg = [UIImage imageNamed:@"icon_camera-selected"];
    
    [imageButton setBackgroundImage:normalImg forState:UIControlStateNormal];
    [imageButton setBackgroundImage:selectedImg forState:UIControlStateSelected];
    return imageButton;
}




@end

