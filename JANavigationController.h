/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *  JANavigationController.h
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

#define kTRANSITION_ANIMATION_DURATION 0.3
#define kNAVIGATION_BAR_HEIGHT         44

@class JANavigationController;

@protocol JANavigationControllerDelegate <NSObject>

- (void) navigationController:(JANavigationController *)controller
	   willShowViewController:(UIViewController *)viewController
					 animated:(BOOL)animated;

- (void) navigationController:(JANavigationController *)controller
		didShowViewController:(UIViewController *)viewController
					 animated:(BOOL)animated;

@end


@interface JANavigationController : UIViewController <UINavigationBarDelegate>
{
	UIView *contentView;
	id<JANavigationControllerDelegate> __unsafe_unretained delegate;
}

@property (strong, nonatomic, readonly)  UIView *contentView;
@property (unsafe_unretained, nonatomic) id<JANavigationControllerDelegate> delegate;
@property (strong, nonatomic, readonly)  UIViewController *topViewController;

// Designated Initializer
- (id)initWithRootViewController:(UIViewController *)viewController;

- (void)pushViewController:(UIViewController *)newViewController animated:(BOOL)animated;
- (void)popViewControllerAnimated:(BOOL)animated;
- (void)popToRootViewControllerAnimated:(BOOL)animated;

- (void)backItemTapped;

@end
