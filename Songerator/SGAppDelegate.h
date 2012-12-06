//
//  SGAppDelegate.h
//  Songerator
//
//  Created by Scott McCoid on 12/6/12.
//  Copyright (c) 2012 Scott McCoid. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGViewController;

@interface SGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SGViewController *viewController;

@end
