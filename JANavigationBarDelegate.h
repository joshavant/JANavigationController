/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *  JANavigationBarDelegate.h
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
 * USING JANavigationBarDelegate TO CONFIGURE THE NAVIGATION BAR VIEW AREA
 * =======================================================================
 *
 * You may optionally adopt this protocol to configure the navigation bar view
 * area.
 *
 * If you don't adopt the protocol, nothing will be displayed in the navigation
 * bar view area.
 *
 * Steps:
 * 1.  Adopt the JANavigationBarDelegate protocol in a UIViewController
 * subclass.
 *
 * 2a. If you want to display a custom background view, @synthesize and
 * implement `customNavigationBarBackgroundView`.
 *
 * 2b. If you want to display a title, @synthesize and implement
 * `customNavigationBarTitle`.
 *
 * These properties should be initialized by the end of `init`.
 *
 */

#import <UIKit/UIKit.h>

@protocol JANavigationBarDelegate <NSObject>

@optional
@property (nonatomic, retain) UIView   *customNavigationBarBackgroundView;
@property (nonatomic, retain) NSString *customNavigationBarTitle;

@end