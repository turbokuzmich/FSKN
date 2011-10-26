//
//  DrugMapViewController.m
//  FSKN 2
//
//  Created by Дмитрий on 28.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DrugMapViewController.h"
#import "FSKN_2AppDelegate.h"


@implementation DrugMapViewController

@synthesize redMap, arrows1, arrows2, arrows3, arrows4, pins, piter, novosib, saratov, replayButton;

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
    [replayButton release];
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
    
    
    // запускаем бесконечную анимацию афганистана
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        redMap.alpha = 1.0f;
    } completion:nil];
    
    [self startArrows1Animation];
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
    self.replayButton = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)startArrows1Animation
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        arrows1.alpha = 1.0f;
    } completion:^(BOOL finished){
        [self startArrows2Animation];
    }];
}

- (void)startArrows2Animation
{
    [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        arrows2.alpha = 1.0f;
    } completion:^(BOOL finished){
        [self startArrows3Animation];
    }];
}

- (void)startArrows3Animation
{
    [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        arrows3.alpha = 1.0f;
    } completion:^(BOOL finished){
        [self startArrows4Animation];
    }];
}

- (void)startArrows4Animation
{
    [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        arrows4.alpha = 1.0f;
    } completion:^(BOOL finished){
        [self startPinsAnimation];
    }];
}

- (void)startPinsAnimation
{
    CGRect pinsRect = CGRectMake(0.0f, 19.0f, 1024.0f, 749.0f);
    
    [UIView animateWithDuration:0.2f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut animations:^{
        pins.frame = pinsRect;
        pins.alpha = 1.0f;
    } completion:^(BOOL finished){
        [self animationsDone];
    }];
}

- (void)animationsDone
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

- (void)replayButtonPressed:(id)sender
{
    if (animationDone) {
        
        piter.hidden = YES;
        novosib.hidden = YES;
        saratov.hidden = YES;
        
        cityShown = NO;
        
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            arrows1.alpha = 0.0f;
            arrows2.alpha = 0.0f;
            arrows3.alpha = 0.0f;
            arrows4.alpha = 0.0f;
            pins.alpha = 0.0f;
        } completion:^(BOOL finished){
            animationDone = NO;
            [self performSelector:@selector(startArrows1Animation) withObject:self afterDelay:1.5f];
        }];
    }
}

@end
