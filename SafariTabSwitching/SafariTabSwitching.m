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
        if ([[NSApplication sharedApplication] respondsToSelector:@selector(frontWindow)]) // check safari API compat
        {
            NSWindow *frontWindow = [[NSApplication sharedApplication] performSelector:@selector(frontWindow)];

            if ([frontWindow respondsToSelector:@selector(orderedTabViewItems)] // check safari API compat
                && [frontWindow respondsToSelector:@selector(setCurrentTabViewItem:)])
            {
                NSArray *tabs = [frontWindow performSelector:@selector(orderedTabViewItems)];
                if (tabs.count >= (tabIndex + 1))
                {
                    [frontWindow performSelector:@selector(setCurrentTabViewItem:) withObject:[tabs objectAtIndex:tabIndex]];
                    return; // prevent event dispatching
                }
            }
        }
    }

    [self SafariTabeSwitching_sendEvent:event];
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
