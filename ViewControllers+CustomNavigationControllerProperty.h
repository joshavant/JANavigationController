/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *  ViewControllers+CustomNavigationControllerProperty.h
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
 * USING ViewControllers+CustomNavigationControllerProperty.h TO CREATE A
 *             STANDARDIZED JANavigationController PROPERTY
 * =======================================================================
 *
 * You may `#import` this category to automagically and conveniently create a
 * JANavigationController property on UIViewController subclasses with a
 * standardized symbol name that this library looks for and implements.
 *
 * This category is specially implemented using runtime tricks so that you
 * simply need to `#import` this file in the public header of the subclass and
 * a `customNavigiationController` property will magically become available.
 * A @synthesize is not needed.
 *
 * The property is declared as `assign`.
 *
 */

#import <UIKit/UIKit.h>

@class JANavigationController;

@interface UIViewController (CustomNavigationControllerProperty)

@property (nonatomic, strong) JANavigationController *customNavigationController;

@end


@interface UITableViewController (CustomNavigationControllerProperty)

@property (nonatomic, strong) JANavigationController *customNavigationController;

@end
