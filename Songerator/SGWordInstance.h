//
//  SGWordInstance.h
//  Songerator
//
//  Created by Jason Clark on 1/30/13.
//  Copyright (c) 2013 Scott McCoid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGWordInstance : UIViewController{
    IBOutlet UILabel *wordLabel;
}

@property (nonatomic,strong) NSString *word;
@property (nonatomic,strong) UIViewController *canvas;

- (id)initWithWord:(NSString *)_word;
- (void)setWord:(NSString *)word;

-(IBAction)longPress:(UILongPressGestureRecognizer*)sender;

@end
