//
//  DrugMapViewController.m
//  FSKN 2
//
//  Created by Дмитрий on 28.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DrugMapViewController.h"

#import "FSKN_2AppDelegate.h"


@implementation DrugMapViewController

@synthesize redMap, arrows1, arrows2, arrows3, arrows4, pins, piter, novosib, saratov;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [piter release];
    [novosib release];
    [saratov release];
    [pins release];
    [redMap release];
    [arrows1 release];
    [arrows2 release];
    [arrows3 release];
    [arrows4 release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    animationDone = NO;
    cityShown = NO;
    piterRect = CGRectMake(61.0f, 43.0f, 37.0f, 60.0f);
    novosibRect = CGRectMake(746.0f, 132.0f, 37.0f, 60.0f);
    saratovRect = CGRectMake(287.0f, 194.0f, 37.0f, 60.0f);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startArrows1Animation:finished:context:)];
    
    redMap.alpha = 1.0f;
    
    [UIView commitAnimations];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.redMap = nil;
    self.arrows1 = nil;
    self.arrows2 = nil;
    self.arrows3 = nil;
    self.arrows4 = nil;
    self.pins = nil;
    self.piter = nil;
    self.novosib = nil;
    self.saratov = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)startArrows1Animation:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startArrows2Animation:finished:context:)];
    
    arrows1.alpha = 1.0f;
    
    [UIView commitAnimations];
}

- (void)startArrows2Animation:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startArrows3Animation:finished:context:)];
    
    arrows2.alpha = 1.0f;
    
    [UIView commitAnimations];
}

- (void)startArrows3Animation:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startArrows4Animation:finished:context:)];
    
    arrows3.alpha = 1.0f;
    
    [UIView commitAnimations];
}

- (void)startArrows4Animation:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startPinsAnimation:finished:context:)];
    
    arrows4.alpha = 1.0f;
    
    [UIView commitAnimations];
}

- (void)startPinsAnimation:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    CGRect pinsRect = CGRectMake(0.0f, 19.0f, 1024.0f, 749.0f);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationsDone:finished:context:)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    pins.frame = pinsRect;
    pins.alpha = 1.0f;
    
    [UIView commitAnimations];
}

- (void)animationsDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    animationDone = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (animationDone && !cityShown) {
        UITouch *touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInView:self.view];
        
        if (CGRectContainsPoint(piterRect, touchLocation)) {
            piter.hidden = NO;
            cityShown = YES;
        }
        
        if (CGRectContainsPoint(novosibRect, touchLocation)) {
            novosib.hidden = NO;
            cityShown = YES;
        }
        
        if (CGRectContainsPoint(saratovRect, touchLocation)) {
            saratov.hidden = NO;
            cityShown = YES;
        }
    }
    
}

- (void)cityBubblePressed:(id)sender
{
    ((UIButton *)sender).hidden = YES;
    cityShown = NO;
}

- (void)backButtonPressed
{
    [(FSKN_2AppDelegate *)[[UIApplication sharedApplication] delegate] goToMain];
}

@end
