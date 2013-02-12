//
//  SGWordListController.m
//  Songerator
//
//  Created by Jason Clark on 1/21/13.
//  Copyright (c) 2013 Scott McCoid. All rights reserved.
//

#import "SGWordListController.h"
#import "SGWordViewController.h"

#define wordSpacingVertical 10
#define wordPadHorizontal 10

@interface SGWordListController ()

@end

@implementation SGWordListController
@synthesize wordArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    float height = 0;
    float width = 89-2*wordPadHorizontal;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"WordList" ofType:@"txt"];
    if (filePath) {
        NSString *contentOfFile = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSArray *words = [contentOfFile componentsSeparatedByString:@"\n"];
        
        for (int i = 0; i<[words count]; i++) {
            
            SGWordViewController *word = [[SGWordViewController alloc] initWithWord:[words objectAtIndex:i]];
            
            if (word.view.frame.size.width>width) {
                width = word.view.frame.size.width;
            }
            
            height = word.view.frame.size.height*(i+1) + wordSpacingVertical*(i+1);
        
        }
        
        [self.view setFrame:CGRectMake(0, 0, width+2*wordPadHorizontal, height+wordSpacingVertical)];
        
        for (int i = 0; i<[words count]; i++) {
            
            SGWordViewController *word = [[SGWordViewController alloc] initWithWord:[words objectAtIndex:i]];
            [word.view setFrame:CGRectMake(wordPadHorizontal, (word.view.frame.size.height*i + wordSpacingVertical*(i+1)),
                                           word.view.frame.size.width, word.view.frame.size.height)];

            [self addChildViewController:word];
            [self.view addSubview:word.view];
        }
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"transparentRtoL"]];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    [imageView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height*2)];
    [self.view insertSubview:imageView atIndex:0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
