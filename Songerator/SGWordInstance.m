//
//  SGWordInstance.m
//  Songerator
//
//  Created by Jason Clark on 1/30/13.
//  Copyright (c) 2013 Scott McCoid. All rights reserved.
//

#import "SGWordInstance.h"


#define SidePad 4
#define AdditionalLeftPad 2
#define TopBottomPad 2

@interface SGWordInstance (){
    
    float dx, dy;
    
}

@end

@implementation SGWordInstance
@synthesize word;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithWord:(NSString *)_word
{
    self = [super init];
    if (self) {
        // Custom initialization        
        word = _word;
        CGSize labelSize = [_word sizeWithFont:[UIFont systemFontOfSize:17]];
        CGSize minSize = [@"the" sizeWithFont:[UIFont systemFontOfSize:17]];
        if (labelSize.width<minSize.width) {
            labelSize = minSize;
        }
        [self.view setFrame:CGRectMake(0, 0, labelSize.width+2*SidePad+AdditionalLeftPad, labelSize.height+2*TopBottomPad)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [wordLabel setText:word];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setWord:(NSString *)_word{
    
    word = _word;
    [wordLabel setText:word];
    CGSize labelSize = [_word sizeWithFont:[UIFont systemFontOfSize:17]];
    CGSize minSize = [@"the" sizeWithFont:[UIFont systemFontOfSize:17]];
    if (labelSize.width<minSize.width) {
        labelSize = minSize;
    }
    
    [self.view setFrame:CGRectMake(0, 0, labelSize.width+2*SidePad+AdditionalLeftPad, labelSize.height+2*TopBottomPad)];
    
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [wordLabel setCenter:CGPointMake(wordLabel.center.x + AdditionalLeftPad, wordLabel.center.y)];
}

-(IBAction)longPress:(UILongPressGestureRecognizer *)sender{
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint point2 = [sender locationInView:self.view];
        dx = self.view.bounds.size.width/2 - point2.x;
        dy = self.view.bounds.size.height/2- point2.y;
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        
        CGPoint point = [sender locationInView:[UIApplication sharedApplication].keyWindow];
        NSNumber *y = [NSNumber numberWithFloat:[UIApplication sharedApplication].keyWindow.frame.size.width - point.x + dy];
        NSNumber *x = [NSNumber numberWithFloat:point.y + dx];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:x,@"x",y,@"y",nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"moveInstance"
                                                            object:self
                                                          userInfo:dict];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        CGPoint point = [sender locationInView:[UIApplication sharedApplication].keyWindow];
        NSNumber *y = [NSNumber numberWithFloat:[UIApplication sharedApplication].keyWindow.frame.size.width - point.x + dy];
        NSNumber *x = [NSNumber numberWithFloat:point.y + dx];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:x,@"x",y,@"y",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dropInstance"
                                                            object:self
                                                          userInfo:dict];
    }

}

@end
