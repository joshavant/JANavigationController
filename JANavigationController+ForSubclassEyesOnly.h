/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *  JANavigationController+ForSubclassEyesOnly.h
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

/**
 * NOTES:
 *
 * This category provides custom JANavigationController subclasses with access
 * to more control around the actions of JANavigationController.
 *
 */

#import "JANavigationController.h"
#import "JATransitionContext.h"
#import "JATouchPassingView.h"

@interface JANavigationController (ForSubclassEyesOnly)

// navigationBarViewContainer is where persistent subviews - back button, menu buttons - should be added
@property (strong, nonatomic) JATouchPassingView *navigationBarViewContainer;

// navigationBarView is where the single view object that appears to be the navigation bar resides
@property (strong, nonatomic) JATouchPassingView *navigationBarView;

@property (strong, nonatomic) NSMutableArray *viewControllers;

- (void)pushTransitionWillBeginWithContext:(JATransitionContext *)context;
- (void)pushAnimationWillAnimateWithContext:(JATransitionContext *)context;
- (void)pushTransitionDidFinishWithContext:(JATransitionContext *)context;

- (void)popTransitionWillBeginWithContext:(JATransitionContext *)context;
- (void)popAnimationWillAnimateWithContext:(JATransitionContext *)context;
- (void)popTransitionDidFinishWithContext:(JATransitionContext *)context;

// this method is called for both push and pop animated transitions
- (void)animationDidFinishWithContext:(JATransitionContext *)context;

@end
