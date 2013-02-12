//
//  SGWordViewController.h
//  Songerator
//
//  Created by Jason Clark on 1/21/13.
//  Copyright (c) 2013 Scott McCoid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGWordViewController : UIViewController{
    float dx, dy;
}

@property (nonatomic,strong) NSString *word;

- (id)initWithWord:(NSString *)_word;
-(IBAction)longPressDetected:(UILongPressGestureRecognizer *)sender;

@end
