# JANavigationController

**A UINavigationController reimplementation that allows total configuration of the navigation bar view area.**

## Overview
This is an iOS library that reimplements `UINavigationController` so child view controllers can configure all aspects of the navigation bar view area, while having the same functionality and API of the native `UINavigationController` object.


## Discussion

### Customizing The Navigation Bar View Area

A UINavigationBar object is not available as a property on `JANavigationController`. Instead, the navigation bar view area is customized by `JANavigationBarDelegate` properties implemented by child `UIViewController` delegates.

For more information on this, see the documentation in `JANavigationBarDelegate.h`.

### customNavigationController Convenience Category

Implementation of a `JANavigationController *customNavigationController` property on UIViewController objects can be accomplished conveniently and automagically by simply adding `#import "ViewControllers+CustomNavigationControllerProperty.h"` to a `UIViewController` subclass's public header file.

Remember to `#import JANavigationController.h` to access the new property's public attributes.

For more information, see the documentation in `ViewControllers+CustomNavigationControllerProperty.h`.

### JANavigationController init-, push-, pop- Methods Try To Set customNavigationController
All `JANavigationController` `init`-, `push`-, and `pop`- methods will attempt to set the `customNavigationController` property on `UIViewController` arguments to itself, if a property with that name exists (i.e. if the convenience category has been `#import`-ed in that `UIViewController` subclass instance).

### JANavigationController+ForSubclassEyesOnly Category
Custom `JANavigationController` subclasses may optionally implement this category for additional functionality. `navigationBarViewContainer` and `navigationBarViewContainer` are the actual properties that contain the navigation bar view area views. 

To add persistent subviews that are always displayed within the navigation bar view area, add them to `navigationBarViewContainer`.

For more information, see the documentation in `JANavigationController+ForSubclassEyesOnly.h`.

## Project Roadmap
* Allow configuration of the entire navigation stack through an accessor method. Currently, only a root view controller can be configured.


## Compatibility
* iOS 4.3+
* ARC


**Contributions, corrections, and improvements are always appreciated!**

## Created By
Josh Avant

## License
This is licensed under a MIT/Beerware License:

    Copyright (c) 2012 Josh Avant

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
    DEALINGS IN THE SOFTWARE.

    If we meet some day, and you think this stuff is worth it, you can buy me a
    beer in return.