//
//  SGEditViewController.m
//  Songerator
//
//  Created by Jason Clark on 1/21/13.
//  Copyright (c) 2013 Scott McCoid. All rights reserved.
//

#import "SGEditViewController.h"

@interface SGEditViewController (){
    
    BOOL leftDrawerToggled;
    BOOL rightDrawerToggled;
    BOOL closedDrawersOnce;
    
    NSMutableArray *scales;
    
}

@end

@implementation SGEditViewController
@synthesize leftDrawer, rightDrawer,canvas, wordList, settingsTitle, scalePicker, bottomToolbar, rightDrawerButton;

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
    // Do any additional setup after loading the view from its nib.

    wordList = [[SGWordListController alloc] init];
    canvas = [[SGCanvasVC alloc] init];
    [canvas.view setFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width-44-44)];
    [canvas.scrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.height * 2, canvas.view.frame.size.height)];
    
    [self.view addSubview:canvas.view];
    [self addChildViewController:canvas];

    [leftDrawer addSubview: wordList.view];
    [leftDrawer setContentSize:wordList.view.frame.size];
    printf("%f",wordList.view.frame.size.width);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addWord:) name:@"addWord" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveWord:) name:@"moveWord" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropWord:) name:@"dropWord" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveInstance:) name:@"moveInstance" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropInstance:) name:@"dropInstance" object:nil];
    
    leftDrawerToggled = NO;
    rightDrawerToggled = NO;
    
    [self.view bringSubviewToFront:rightDrawer];
    carrier = [[SGWordInstance alloc] initWithWord:@"_word"];
    [self addChildViewController:carrier];
    [self.view addSubview:carrier.view];
    [carrier.view setHidden:YES];
    
    UIView *settingsView = [[[NSBundle mainBundle] loadNibNamed:@"SettingsView" owner:self options:nil] objectAtIndex:0];
    [rightDrawer addSubview:settingsView];
    [rightDrawer setContentSize:settingsView.frame.size];
    [rightDrawer setDelegate:self];
    
    [self.view insertSubview:rightDrawer atIndex:0];
    [self.view insertSubview:bottomToolbar atIndex:0];
    [self.view insertSubview:canvas.view atIndex:0];
    
    scales = [[NSMutableArray alloc] initWithObjects:@"Chromatic",@"Major",@"Minor", nil];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    
    [self restoreDrawerLeft:leftDrawerToggled andRight:rightDrawerToggled];

    [super viewDidLayoutSubviews];
}

-(IBAction)playButtonPressed{
    
    for (SGWordInstance *subview in [canvas childViewControllers])
    {
        NSLog(@"word: %@",[subview word]);
        NSLog(@"xcoor: %f",subview.view.frame.origin.x);
        NSLog(@"ycoor: %f",subview.view.center.y);
        
    };
 
    
    
    
}


-(void)restoreDrawerLeft:(BOOL)left andRight: (BOOL)right{
    
    [leftDrawer setCenter:CGPointMake(leftDrawer.frame.size.width/2 * (left ? 1 : -1), leftDrawer.center.y)];
    
    [rightDrawer setCenter:CGPointMake([UIScreen mainScreen].bounds.size.height + rightDrawer.frame.size.width/2 * (right ? -1 : 1), rightDrawer.center.y)];
    
    [canvas.view setFrame:CGRectMake((left ? leftDrawer.frame.size.width : 0), canvas.view.frame.origin.y, [UIScreen mainScreen].bounds.size.height - (left ? leftDrawer.frame.size.width : 0) - (right ? rightDrawer.frame.size.width : 0), canvas.view.frame.size.height)];
    
    if (rightDrawerToggled) {
    [rightDrawerButton setCenter:CGPointMake([UIScreen mainScreen].bounds.size.height-rightDrawer.frame.size.width-rightDrawerButton.frame.size.width/2, rightDrawerButton.center.y)];
    }
    else [rightDrawerButton setCenter:CGPointMake([UIScreen mainScreen].bounds.size.height-rightDrawerButton.frame.size.width/2, rightDrawerButton.center.y)];
    
    if (leftDrawerToggled) {
    [bottomToolbar setFrame:CGRectMake(leftDrawerToggled ? leftDrawer.frame.size.width : 0, bottomToolbar.frame.origin.y, [UIScreen mainScreen].bounds.size.height - (leftDrawerToggled ? leftDrawer.frame.size.width : 0) - (rightDrawerToggled ? rightDrawer.frame.size.width : 0),bottomToolbar.frame.size.height)];
        
    [rightDrawerButton setCenter:CGPointMake([UIScreen mainScreen].bounds.size.height-rightDrawer.frame.size.width-rightDrawerButton.frame.size.width/2-leftDrawer.frame.size.width, rightDrawerButton.center.y)];
    }
    
}

-(IBAction)leftDrawerToggled{
    
    leftDrawerToggled = !leftDrawerToggled;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews)
                     animations:^{
                         
                         if (rightDrawerToggled){
                             rightDrawerToggled = !rightDrawerToggled;
                             
                             [rightDrawer setCenter:CGPointMake([UIScreen mainScreen].bounds.size.height + rightDrawer.frame.size.width/2 * (rightDrawerToggled ? -1 : 1), rightDrawer.center.y)];
   
                         }
                         
                         [leftDrawer setCenter:CGPointMake(leftDrawer.frame.size.width/2 * (leftDrawerToggled ? 1 : -1), leftDrawer.center.y)];
                         
                         [canvas.view setFrame:CGRectMake((leftDrawerToggled ? leftDrawer.frame.size.width : 0), canvas.view.frame.origin.y, [UIScreen mainScreen].bounds.size.height - (leftDrawerToggled ? leftDrawer.frame.size.width : 0) - (rightDrawerToggled ? rightDrawer.frame.size.width : 0), canvas.view.frame.size.height)];
                         
                         [bottomToolbar setFrame:CGRectMake(leftDrawerToggled ? leftDrawer.frame.size.width : 0, bottomToolbar.frame.origin.y, [UIScreen mainScreen].bounds.size.height - (leftDrawerToggled ? leftDrawer.frame.size.width : 0) - (rightDrawerToggled ? rightDrawer.frame.size.width : 0),bottomToolbar.frame.size.height)];
                         
                          [rightDrawerButton setCenter:CGPointMake([UIScreen mainScreen].bounds.size.height-rightDrawer.frame.size.width-rightDrawerButton.frame.size.width/2-leftDrawer.frame.size.width, rightDrawerButton.center.y)];
                         
                     }
                     completion:^(BOOL finished){ 
                     }];
    
        
    
}

-(IBAction)rightDrawerToggled{
    
    rightDrawerToggled = !rightDrawerToggled;
    
    if (rightDrawerToggled) {

        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews)
                         animations:^{
                             
                             if (leftDrawerToggled) {
                                 leftDrawerToggled = !leftDrawerToggled;
                                 [leftDrawer setCenter:CGPointMake(leftDrawer.frame.size.width/2 * (leftDrawerToggled ? 1 : -1), leftDrawer.center.y)];
                             }
                             
                             //[bottomToolbar setFrame:CGRectMake(leftDrawerToggled ? leftDrawer.frame.size.width : 0, bottomToolbar.frame.origin.y, [UIScreen mainScreen].bounds.size.height - (leftDrawerToggled ? leftDrawer.frame.size.width : 0) - (rightDrawerToggled ? rightDrawer.frame.size.width : 0),bottomToolbar.frame.size.height)];
                             
                             [rightDrawer setCenter:CGPointMake([UIScreen mainScreen].bounds.size.height + rightDrawer.frame.size.width/2 * (rightDrawerToggled ? -1 : 1), rightDrawer.center.y)];
                             
                             
                             [rightDrawerButton setCenter:CGPointMake([UIScreen mainScreen].bounds.size.height-rightDrawer.frame.size.width-rightDrawerButton.frame.size.width/2, rightDrawerButton.center.y)];
                             
                         }
                         completion:^(BOOL finished){
                             
                              [canvas.view setFrame:CGRectMake((leftDrawerToggled ? leftDrawer.frame.size.width : 0), canvas.view.frame.origin.y, [UIScreen mainScreen].bounds.size.height - (leftDrawerToggled ? leftDrawer.frame.size.width : 0) - (rightDrawerToggled ? rightDrawer.frame.size.width : 0), canvas.view.frame.size.height)];
                             
                         }];
    }
    
    else {
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews)
                         animations:^{
                             [rightDrawer setCenter:CGPointMake([UIScreen mainScreen].bounds.size.height + rightDrawer.frame.size.width/2 * (rightDrawerToggled ? -1 : 1), rightDrawer.center.y)];
                             
                                //[bottomToolbar setFrame:CGRectMake(leftDrawerToggled ? leftDrawer.frame.size.width : 0, bottomToolbar.frame.origin.y, [UIScreen mainScreen].bounds.size.height - (leftDrawerToggled ? leftDrawer.frame.size.width : 0) - (rightDrawerToggled ? rightDrawer.frame.size.width : 0),bottomToolbar.frame.size.height)];
                             
                             [canvas.view setFrame:CGRectMake((leftDrawerToggled ? leftDrawer.frame.size.width : 0), canvas.view.frame.origin.y, [UIScreen mainScreen].bounds.size.height - (leftDrawerToggled ? leftDrawer.frame.size.width : 0) - (rightDrawerToggled ? rightDrawer.frame.size.width : 0), canvas.view.frame.size.height)];
                             
                             [rightDrawerButton setCenter:CGPointMake([UIScreen mainScreen].bounds.size.height-rightDrawerButton.frame.size.width/2, rightDrawerButton.center.y)];
                             
                         }
                         completion:^(BOOL finished){
                         
                         }];
        
    }
    


}

-(void)addWord:(NSNotification *)notification{
    
    NSString *word = [[notification userInfo] valueForKey:@"word"];
    NSNumber *x = [[notification userInfo] valueForKey:@"x"];
    NSNumber *y = [[notification userInfo] valueForKey:@"y"];
    
    [carrier setWord:word];
    [carrier.view setHidden:NO];
    [carrier.view setCenter:CGPointMake([x floatValue], [y floatValue])];
      
}

-(void)moveWord:(NSNotification *)notification{
    
    NSNumber *x = [[notification userInfo] valueForKey:@"x"];
    NSNumber *y = [[notification userInfo] valueForKey:@"y"];
    [carrier.view setCenter:CGPointMake([x floatValue], [y floatValue])];
    
}

-(void)dropWord:(NSNotification *)notification{
    
    NSNumber *x = [[notification userInfo] valueForKey:@"x"];
    NSNumber *y = [[notification userInfo] valueForKey:@"y"];
    
    // TODO only one word can be dragged.
    
    if (CGRectContainsPoint(canvas.view.frame, CGPointMake([x floatValue], [y floatValue]))){
        SGWordInstance *word = [[SGWordInstance alloc]initWithWord:carrier.word];
        [word.view setCenter:CGPointMake([x floatValue] - canvas.view.frame.origin.x + canvas.scrollView.contentOffset.x, [y floatValue] - canvas.view.frame.origin.y)];
        [canvas.scrollView addSubview:word.view];
        [canvas addChildViewController:word];
    }
    
    [carrier.view setHidden:YES];
    [carrier setWord:@"#WORD"];
    
}

-(void)moveInstance:(NSNotification *)notification{
    
    NSNumber *x = [[notification userInfo] valueForKey:@"x"];
    NSNumber *y = [[notification userInfo] valueForKey:@"y"];
    
    UIViewController *sender = [notification object];
    [[sender.view superview] bringSubviewToFront:sender.view];
    [sender.view setCenter:CGPointMake([x floatValue] - canvas.view.frame.origin.x + canvas.scrollView.contentOffset.x, [y floatValue] - canvas.view.frame.origin.y)];

    
}

-(void)dropInstance:(NSNotification *)notification{
    
    //TODO, figure out a more intuitive means of deletion.
    
    //NSNumber *x = [[notification userInfo] valueForKey:@"x"];
    NSNumber *y = [[notification userInfo] valueForKey:@"y"];
    
    UIViewController *sender = [notification object];
    if ([y floatValue] < canvas.view.frame.origin.y){
        [sender.view removeFromSuperview];
        [sender removeFromParentViewController];
    }
    

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == rightDrawer) {
        float offset = [scrollView contentOffset].y;
        if (offset < 0) offset = 0;
            [settingsTitle setCenter:CGPointMake(settingsTitle.center.x, offset + settingsTitle.frame.size.height/2)];
    }
     
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [scales objectAtIndex:row];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [scales count];
}

-(void)tempoSliderChanged{
    
}

@end
