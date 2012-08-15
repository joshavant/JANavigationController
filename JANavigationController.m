/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *  JANavigationController.m
 *
 *  Copyright (c) 2012 Josh Avant
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a
 *  copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation
 *  the rights to use, copy, modify, merge, publish, distribute, sublicense,
 *  and/or sell copies of the Software, and to permit persons to whom the
 *  Software is furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 *  DEALINGS IN THE SOFTWARE.
 *
 *  If we meet some day, and you think this stuff is worth it, you can buy me a
 *  beer in return.
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

#import "JANavigationController.h"
#import "JANavigationBarDelegate.h"
#import "ViewControllers+CustomNavigationControllerProperty.h"
#import "JATransitionContext.h"
#import "JANavigationController+ForSubclassEyesOnly.h"

#define kCURRENT_NAVIGATIONBARVIEW_TAG 10000
#define kNEW_NAVIGATIONBARVIEW_TAG     10001

@interface JANavigationController ()

@property (strong, nonatomic) JATouchPassingView *navigationBarViewContainer;
@property (strong, nonatomic) JATouchPassingView *navigationBarView;
@property (strong, nonatomic) NSMutableArray *viewControllers;

@property (strong, nonatomic, readwrite) UIView *contentView;

- (JATouchPassingView *)viewForNavigationBarFromViewController:(UIViewController *)viewController;
- (UIView *)viewForNavigationBarLabelFromTitleString:(NSString *)title;
- (void)unanimatedTransitionWithContext:(JATransitionContext *)context
                andNewNavigationBarView:(UIView *)newNavigationBarView;
@end


@implementation JANavigationController

@synthesize topViewController;
@synthesize contentView;
@synthesize delegate;
@synthesize navigationBarViewContainer;
@synthesize navigationBarView;
@synthesize viewControllers;

- (id)initWithRootViewController:(UIViewController *)viewController
{
    NSParameterAssert(viewController != nil);
    
	if (self = [super init])
	{
        if([viewController respondsToSelector:@selector(setCustomNavigationController:)])
        {
            viewController.customNavigationController = self;   
        }
        
		self.viewControllers = [[NSMutableArray alloc] initWithObjects: viewController, nil];
	}
	return self;
}

- (id)init
{
    return [self initWithRootViewController:nil];
}

- (void)loadView
{
    UIView *newView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	newView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

    CGRect navigationBarFrame = CGRectMake(0.f,
                                           0.f,
                                           newView.frame.size.width,
                                           kNAVIGATION_BAR_HEIGHT);
    
    self.navigationBarViewContainer = [[JATouchPassingView alloc] initWithFrame:navigationBarFrame];
    self.navigationBarViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.navigationBarView = [[JATouchPassingView alloc] initWithFrame:navigationBarFrame];
    JATouchPassingView *currentNavigationBarView = [self viewForNavigationBarFromViewController:[self.viewControllers objectAtIndex:0]];
    currentNavigationBarView.tag = kCURRENT_NAVIGATIONBARVIEW_TAG;
    
    self.contentView = [[UIView alloc] initWithFrame:newView.frame];
	self.contentView.clipsToBounds = NO;
	self.contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [newView addSubview:contentView];
    [self.contentView addSubview:self.navigationBarViewContainer];
    [self.navigationBarView addSubview:currentNavigationBarView];
    [self.navigationBarViewContainer addSubview:self.navigationBarView];
    
    self.view = newView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	if ([self.viewControllers count] > 0)
	{
		UIViewController *currentViewController = [self.viewControllers lastObject];
		
		if (delegate != nil)
			[delegate navigationController:self
					willShowViewController:currentViewController
								  animated:NO];

		[contentView insertSubview:currentViewController.view atIndex:0];
        
		currentViewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		currentViewController.view.frame = contentView.bounds;
		
		if (delegate != nil)
			[delegate navigationController:self
					 didShowViewController:currentViewController
								  animated:NO];
	}
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark -
#pragma mark Custom Getter methods
- (UIViewController *)topViewController
{
    return [self.viewControllers lastObject];
}


#pragma mark -
#pragma mark Drawing methods
- (JATouchPassingView *)viewForNavigationBarFromViewController:(UIViewController *)viewController
{
    JATouchPassingView *navBarView = [[JATouchPassingView alloc] initWithFrame:self.navigationBarViewContainer.bounds];
    navBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    if([viewController conformsToProtocol:@protocol(JANavigationBarDelegate)])
    {
        UIViewController <JANavigationBarDelegate> *navBarDelegate =
            (UIViewController <JANavigationBarDelegate> *) viewController;
        
        if([navBarDelegate respondsToSelector:@selector(customNavigationBarBackgroundView)] &&
           navBarDelegate.customNavigationBarBackgroundView != nil)
        {
            navBarDelegate.customNavigationBarBackgroundView.center = navBarView.center;
            [navBarView addSubview:navBarDelegate.customNavigationBarBackgroundView];   
        }
        
        if([navBarDelegate respondsToSelector:@selector(customNavigationBarTitle)] &&
           navBarDelegate.customNavigationBarTitle != nil)
        {
            UIView *navigationBarLabelView = [self viewForNavigationBarLabelFromTitleString:navBarDelegate.customNavigationBarTitle];
            navigationBarLabelView.center = navBarView.center;
            [navBarView addSubview:navigationBarLabelView];
        }
    }
    
    return navBarView;
}

- (UIView *)viewForNavigationBarLabelFromTitleString:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = title;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.f];
    titleLabel.shadowColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.userInteractionEnabled = NO;
    [titleLabel sizeToFit];
    
    return titleLabel;
}

#pragma mark -
#pragma mark Animation subclass methods

#pragma mark Push methods
- (void)pushTransitionWillBeginWithContext:(JATransitionContext *)context
{
    // nothing, as of yet.
}

- (void)pushAnimationWillAnimateWithContext:(JATransitionContext *)context
{
    // nothing as of yet
}

- (void)pushTransitionDidFinishWithContext:(JATransitionContext *)context
{
    // nothing as of yet
}

#pragma mark Pop methods
- (void)popTransitionWillBeginWithContext:(JATransitionContext *)context
{
    // nothing as of yet
}

- (void)popAnimationWillAnimateWithContext:(JATransitionContext *)context
{
    // nothing as of yet
}

- (void)popTransitionDidFinishWithContext:(JATransitionContext *)context
{
    // nothing as of yet
}

- (void)animationDidFinishWithContext:(JATransitionContext *)context
{
	[context.disappearingController.view removeFromSuperview];

    [context.disappearingController viewDidDisappear:YES];
    [context.appearingController viewDidAppear:YES];
    
    if (delegate != nil)
        [delegate navigationController:self
                 didShowViewController:context.appearingController
                              animated:YES];
}

#pragma mark -
#pragma mark NavigationController methods

- (void)pushViewController:(UIViewController *)newViewController
                  animated:(BOOL)animated
{
    if([newViewController respondsToSelector:@selector(setCustomNavigationController:)])
    {
        newViewController.customNavigationController = self;   
    }
    
	UIViewController *currentViewController = nil;
    
	if ([self.viewControllers count] > 0)
		currentViewController = [self.viewControllers lastObject];
    
	[self.viewControllers addObject:newViewController];
	
    JATransitionContext *context = [JATransitionContext new];
    context.disappearingController = currentViewController;
    context.appearingController = newViewController;
    
    if (currentViewController != nil)
    {
        [contentView insertSubview:newViewController.view aboveSubview:currentViewController.view];
    }
    else
    {
        [contentView addSubview:newViewController.view];
    }
    
    newViewController.view.frame = CGRectMake(contentView.bounds.size.width,
                                              0,
                                              contentView.bounds.size.width,
                                              contentView.bounds.size.height);
    
    
    JATouchPassingView *newNavigationBarView = [self viewForNavigationBarFromViewController:newViewController];
    [self.navigationBarView addSubview:newNavigationBarView];
    newNavigationBarView.tag = kNEW_NAVIGATIONBARVIEW_TAG;
    newNavigationBarView.frame = CGRectMake(contentView.bounds.size.width,
                                            0,
                                            contentView.bounds.size.width,
                                            kNAVIGATION_BAR_HEIGHT);
    
	if (delegate != nil)
		[delegate navigationController:self
				willShowViewController:newViewController
							  animated:animated];
	
    [currentViewController viewWillDisappear:animated];
    [newViewController viewWillAppear:animated];
    
    [self pushTransitionWillBeginWithContext:context];
    
	if(animated)
    {
        [UIView animateWithDuration:kTRANSITION_ANIMATION_DURATION
                              delay:0
                            options:(UIViewAnimationCurveEaseInOut | UIViewAnimationOptionTransitionNone)
                         animations:^{
                             [self pushAnimationWillAnimateWithContext:context];
                             
                             // current views
                             if (currentViewController != nil)
                             {
                                 CGRect currentViewControllerNewFrame = currentViewController.view.frame;
                                 currentViewControllerNewFrame.origin.x = -contentView.bounds.size.width;

                                 currentViewController.view.frame = currentViewControllerNewFrame;
                             }
                             
                             UIView *currentNavigationBarView = [self.navigationBarView viewWithTag:kCURRENT_NAVIGATIONBARVIEW_TAG];
                             
                             if(currentNavigationBarView != nil)
                             {
                                 CGRect currentNavigationBarViewNewFrame = currentNavigationBarView.frame;
                                 currentNavigationBarViewNewFrame.origin.x = -contentView.bounds.size.width;
                                 
                                 currentNavigationBarView.frame = currentNavigationBarViewNewFrame;
                             }
                             
                             // new views
                             newViewController.view.frame = CGRectMake(0,
                                                                       0,
                                                                       contentView.bounds.size.width,
                                                                       contentView.bounds.size.height);
                             
                             newNavigationBarView.frame = CGRectMake(0,
                                                                     0,
                                                                     contentView.bounds.size.width,
                                                                     kNAVIGATION_BAR_HEIGHT);                             
                         }
                         completion:^(BOOL finished) {
                             if(finished)
                             {
                                 [[self.navigationBarView viewWithTag:kCURRENT_NAVIGATIONBARVIEW_TAG] removeFromSuperview];
                                 [self.navigationBarView viewWithTag:kNEW_NAVIGATIONBARVIEW_TAG].tag = kCURRENT_NAVIGATIONBARVIEW_TAG;
                                 
                                 [currentViewController viewDidDisappear:animated];
                                 [newViewController viewDidAppear:animated];
                                 
                                 [self pushTransitionDidFinishWithContext:context];
                                 [self animationDidFinishWithContext:context];
                             }
                         }];
    }
    else
    {
        [self pushAnimationWillAnimateWithContext:context];
        [self unanimatedTransitionWithContext:context andNewNavigationBarView:newNavigationBarView];
        [self pushTransitionDidFinishWithContext:context];
        
        [currentViewController viewDidDisappear:animated];
        [newViewController viewDidAppear:animated];
    }
}

- (void)popViewControllerAnimated:(BOOL)animated
{
	if ([self.viewControllers count] == 1)
		return;
    
	UIViewController *currentViewController = [self.viewControllers lastObject];
    if([currentViewController respondsToSelector:@selector(setCustomNavigationController:)])
    {
        currentViewController.customNavigationController = nil;
    }
    
	[self.viewControllers removeLastObject];
	UIViewController *newViewController = [self.viewControllers lastObject];
	
    JATransitionContext *context = [JATransitionContext new];
    context.disappearingController = currentViewController;
    context.appearingController = newViewController;
    
    [contentView insertSubview:newViewController.view atIndex:0];

    JATouchPassingView *newNavigationBarView = [self viewForNavigationBarFromViewController:newViewController];
    [self.navigationBarView addSubview:newNavigationBarView];
    newNavigationBarView.tag = kNEW_NAVIGATIONBARVIEW_TAG;
    newNavigationBarView.frame = CGRectMake(-contentView.bounds.size.width,
                                            0,
                                            contentView.bounds.size.width,
                                            kNAVIGATION_BAR_HEIGHT);
    
	if (delegate != nil)
		[delegate navigationController:self
				willShowViewController:newViewController
							  animated:animated];
	
    [currentViewController viewWillDisappear:animated];
    [newViewController viewWillAppear:animated];
    
    [self popTransitionWillBeginWithContext:context];
    
	if(animated)
    {
        [UIView animateWithDuration:kTRANSITION_ANIMATION_DURATION
                              delay:0
                            options:(UIViewAnimationCurveEaseInOut | UIViewAnimationOptionTransitionNone)
                         animations:^{
                             [self popAnimationWillAnimateWithContext:context];
                             
                             // current views
                             CGRect currentViewControllerNewFrame = currentViewController.view.frame;
                             currentViewControllerNewFrame.origin.x = contentView.bounds.size.width;
                             
                             currentViewController.view.frame = currentViewControllerNewFrame;
                             
                             UIView *currentNavigationBarView = [self.navigationBarView viewWithTag:kCURRENT_NAVIGATIONBARVIEW_TAG];
                             
                             CGRect currentNavigationBarViewNewFrame = currentNavigationBarView.frame;
                             currentNavigationBarViewNewFrame.origin.x = contentView.bounds.size.width;
                             
                             currentNavigationBarView.frame = currentNavigationBarViewNewFrame;
                             
                             // new views
                             newViewController.view.frame = CGRectMake(0,
                                                                       0,
                                                                       contentView.bounds.size.width,
                                                                       contentView.bounds.size.height);
                             
                             newNavigationBarView.frame = CGRectMake(0,
                                                                     0,
                                                                     contentView.bounds.size.width,
                                                                     kNAVIGATION_BAR_HEIGHT);

                         }
                         completion:^(BOOL finished) {
                             if(finished)
                             {
                                 [[self.navigationBarView viewWithTag:kCURRENT_NAVIGATIONBARVIEW_TAG] removeFromSuperview];
                                 [self.navigationBarView viewWithTag:kNEW_NAVIGATIONBARVIEW_TAG].tag = kCURRENT_NAVIGATIONBARVIEW_TAG;
                                 
                                 [currentViewController viewDidDisappear:animated];
                                 [newViewController viewDidAppear:animated];
                                 
                                 [self popTransitionDidFinishWithContext:context];
                                 [self animationDidFinishWithContext:context];
                             }
                         }];
    }
    else
    {
        [self popAnimationWillAnimateWithContext:context];
        [self unanimatedTransitionWithContext:context andNewNavigationBarView:newNavigationBarView];
        [self popTransitionDidFinishWithContext:context];
        
        [currentViewController viewDidDisappear:animated];
        [newViewController viewDidAppear:animated];
    }
}

- (void)unanimatedTransitionWithContext:(JATransitionContext *)context
                andNewNavigationBarView:(UIView *)newNavigationBarView

{
    context.appearingController.view.frame = CGRectMake(0,
                                                        0,
                                                        contentView.bounds.size.width,
                                                        contentView.bounds.size.height);
    
    newNavigationBarView.frame = CGRectMake(0,
                                            0,
                                            contentView.bounds.size.width,
                                            kNAVIGATION_BAR_HEIGHT);
    
    [contentView insertSubview:context.appearingController.view atIndex:0];
    [context.disappearingController.view removeFromSuperview];
    
    [self.navigationBarView addSubview:newNavigationBarView];
    [[self.navigationBarView viewWithTag:kCURRENT_NAVIGATIONBARVIEW_TAG] removeFromSuperview];
    [self.navigationBarView viewWithTag:kNEW_NAVIGATIONBARVIEW_TAG].tag = kCURRENT_NAVIGATIONBARVIEW_TAG;
    
    [contentView setNeedsDisplay];
    [self.navigationBarView setNeedsDisplay];
}

- (void)popToRootViewControllerAnimated:(BOOL)animated
{
    while ([self.viewControllers count] > 1)
    {
        [self popViewControllerAnimated:animated];
    }
}

- (void)backItemTapped
{
	[self popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark View appearance methods

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.topViewController viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{    
    [self.topViewController viewWillDisappear:animated];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.topViewController viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{    
    [self.topViewController viewDidDisappear:animated];
    
    [super viewDidDisappear:animated];
}

@end
