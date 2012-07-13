//
//  CTViewController.m
//  CTDownloadProgressButtonSampleProject
//
//  Created by Oliver Letterer on 13.07.12.
//  Copyright 2012 ebf. All rights reserved.
//

#import "CTViewController.h"
#import "CTDownloadProgressButton.h"



@interface CTViewController () {
    CTDownloadProgressButton *_progressButton;
    UIButton *_startDownloadButton;
    NSTimer *_timer;
}

- (void)_timerCallback:(NSTimer *)timer;

- (void)_startDownloadButtonClicked:(UIButton *)sender;
- (void)_stopDownloadButtonClicked:(CTDownloadProgressButton *)sender;

@end



@implementation CTViewController

#pragma mark - setters and getters

#pragma mark - Initialization

- (id)init
{
    if (self = [super init]) {
        // Custom initialization
        
    }
    return self;
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    
    _startDownloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_startDownloadButton setTitle:@"Start download" forState:UIControlStateNormal];
    [_startDownloadButton sizeToFit];
    _startDownloadButton.center = CGPointMake(100.0f, 75.0f);
    [_startDownloadButton addTarget:self action:@selector(_startDownloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_startDownloadButton];
    
    _progressButton = [[CTDownloadProgressButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 29.0f, 29.0f)];
    _progressButton.center = _startDownloadButton.center;
    [_progressButton addTarget:self action:@selector(_stopDownloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = _progressButton.backgroundColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

#pragma mark - Private category implementation ()

- (void)_timerCallback:(NSTimer *)timer
{
    _progressButton.progress += 0.01f;
    
    if (_progressButton.progress >= 1.0f) {
        _progressButton.progress = 0.0f;
    }
}

- (void)_startDownloadButtonClicked:(UIButton *)sender
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(_timerCallback:) userInfo:nil repeats:YES];
    [_startDownloadButton removeFromSuperview];
    [self.view addSubview:_progressButton];
    _progressButton.progress = 0.0f;
}

- (void)_stopDownloadButtonClicked:(CTDownloadProgressButton *)sender
{
    [_timer invalidate];
    
    [_progressButton removeFromSuperview];
    [self.view addSubview:_startDownloadButton];
}

@end
