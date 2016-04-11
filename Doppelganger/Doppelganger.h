//
//  Doppelganger.h
//  Pods
//
//  Created by Sash Zats on 1/8/15.
//
//

#import <UIKit/UIKit.h>

//! Project version number for Doppelganger.
FOUNDATION_EXPORT double DoppelgangerVersionNumber;

//! Project version string for Doppelganger.
FOUNDATION_EXPORT const unsigned char DoppelgangerVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Doppelganger/PublicHeader.h>

#import "WMLArrayDiffUtility.h"
#import "WMLArrayDiff.h"
#import "WMLArrayDiff+Creation.h"
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
    #import "UIKit+Doppelganger.h"
#elif TARGET_OS_MAC

#endif