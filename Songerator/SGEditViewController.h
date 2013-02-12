//
//  SGEditViewController.h
//  Songerator
//
//  Created by Jason Clark on 1/21/13.
//  Copyright (c) 2013 Scott McCoid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGWordListController.h"
#import "SGWordViewController.h"
#import "SGWordInstance.h"
#import "SGCanvasVC.h"

@interface SGEditViewController : UIViewController <UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{
    
    SGWordInstance *carrier;
}

//left drawer
@property (nonatomic,retain) IBOutlet UIScrollView *leftDrawer;
@property (nonatomic,retain) SGWordListController *wordList;

//right drawer
@property (nonatomic,retain) IBOutlet UIScrollView *rightDrawer;
@property (nonatomic,retain) IBOutlet UIView *settingsTitle;
@property (nonatomic,retain) IBOutlet UIPickerView *scalePicker;

//bottom toolbar
@property (nonatomic,retain) IBOutlet UIView *bottomToolbar;
@property (nonatomic,retain) IBOutlet UIButton *rightDrawerButton;

//canvas
@property (nonatomic,retain) SGCanvasVC *canvas;

-(IBAction)playButtonPressed;
-(IBAction)leftDrawerToggled;
-(IBAction)rightDrawerToggled;
-(IBAction)tempoSliderChanged;


@end
