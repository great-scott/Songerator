//
//  SGViewController.m
//  Songerator
//
//  Created by Scott McCoid on 12/6/12.
//  Copyright (c) 2012 Scott McCoid. All rights reserved.
//

#import "SGViewController.h"
#import "SGEditViewController.h"

@interface SGViewController ()

@end

@implementation SGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)editViewButtonPressed{
    SGEditViewController *editView = [[SGEditViewController alloc] init];
    [self presentViewController:editView animated:NO completion:nil];
}

@end
