//
//  SafariTabSwitching.m
//  SafariTabSwitching
//
//  Created by Olivier Poitrey on 10/07/11.
//  Copyright 2011 Dailymotion. All rights reserved.
//

#import "JRSwizzle.h"

@implementation NSApplication(SafariTabSwitching)

- (void)SafariTabeSwitching_sendEvent:(NSEvent *)event
{
    if (event.type == NSKeyDown
        && (event.modifierFlags & NSDeviceIndependentModifierFlagsMask) == NSCommandKeyMask // only command modifier pressed
        && event.keyCode >= 18 && event.keyCode <= 25)
    {
        NSUInteger tabIndex = event.keyCode - 18;
        NSWindow *frontWindow = [[NSApplication sharedApplication] frontWindow];
        if ([[frontWindow orderedTabViewItems] count] >= (tabIndex + 1))
        {
            [frontWindow setCurrentTabViewItem:[[frontWindow orderedTabViewItems] objectAtIndex:tabIndex]];
        }
    }
    else
    {
        [self SafariTabeSwitching_sendEvent:event];
    }
}

@end

@interface SafariTabSwitching : NSObject
@end

@implementation SafariTabSwitching

+ (void)load
{
    NSLog(@"Safari Tab Switching Loaded");
    [NSClassFromString(@"BrowserApplication") jr_swizzleMethod:@selector(sendEvent:) withMethod:@selector(SafariTabeSwitching_sendEvent:) error:NULL];

}

@end
