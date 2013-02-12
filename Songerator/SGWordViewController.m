//
//  SGWordViewController.m
//  Songerator
//
//  Created by Jason Clark on 1/21/13.
//  Copyright (c) 2013 Scott McCoid. All rights reserved.
//

#import "SGWordViewController.h"

#define AdditionalLeftPad 2
#define SidePad 4
#define TopBottomPad 2

@interface SGWordViewController (){
    
    IBOutlet UILabel *wordLabel;
        
}

@end

@implementation SGWordViewController
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
        [self.view setFrame:CGRectMake(0, 0, labelSize.width+SidePad*2+AdditionalLeftPad, labelSize.height+2*TopBottomPad)];
        
    }
    return self;
}

-(void)setWord:(NSString *)_word {
    //this should never be called
    
    word = _word;
    [wordLabel setText:_word];
    
}

-(IBAction)longPressDetected:(UILongPressGestureRecognizer *)sender{
    
    if (sender.state == UIGestureRecognizerStateBegan) {   
        
        CGPoint point = [sender locationInView:[UIApplication sharedApplication].keyWindow];
        CGPoint point2 = [sender locationInView:self.view];
        dx = self.view.bounds.size.width/2 - point2.x;
        dy = self.view.bounds.size.height/2- point2.y;
        
        NSNumber *y = [NSNumber numberWithFloat:[UIApplication sharedApplication].keyWindow.frame.size.width - point.x + dy];
        NSNumber *x = [NSNumber numberWithFloat:point.y + dx];
        
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:word,@"word",x,@"x",y,@"y",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addWord"
                                                            object:self
                                                          userInfo:dict];
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        
        CGPoint point = [sender locationInView:[UIApplication sharedApplication].keyWindow];
        NSNumber *y = [NSNumber numberWithFloat:[UIApplication sharedApplication].keyWindow.frame.size.width - point.x + dy];
        NSNumber *x = [NSNumber numberWithFloat:point.y + dx];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:x,@"x",y,@"y",nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"moveWord"
                                                            object:self
                                                          userInfo:dict];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        CGPoint point = [sender locationInView:[UIApplication sharedApplication].keyWindow];
        NSNumber *y = [NSNumber numberWithFloat:[UIApplication sharedApplication].keyWindow.frame.size.width - point.x + dy];
        NSNumber *x = [NSNumber numberWithFloat:point.y + dx];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:x,@"x",y,@"y",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dropWord"
                                                            object:self
                                                          userInfo:dict];
    }

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [wordLabel setText:word];

}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    [wordLabel setCenter:CGPointMake(wordLabel.center.x + AdditionalLeftPad, wordLabel.center.y)];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
