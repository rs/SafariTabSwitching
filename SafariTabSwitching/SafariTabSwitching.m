//
//  SafariTabSwitching.m
//  SafariTabSwitching
//
//  Created by Olivier Poitrey on 10/07/11.
//  Copyright 2011 Dailymotion. All rights reserved.
//

#import "SafariTabSwitching.h"
#import "JRSwizzle.h"

@implementation NSApplication(SafariTabSwitching)

- (void)SafariTabeSwitching_sendEvent:(NSEvent *)event
{
    static NSArray *keyCode2TabIndex = nil;

    if (event.type == NSKeyDown
        && (event.modifierFlags & NSDeviceIndependentModifierFlagsMask) == NSCommandKeyMask) // only command modifier pressed
    {
        if (!keyCode2TabIndex)
        {
            keyCode2TabIndex = [[NSArray alloc] initWithObjects:@"18", @"19", @"20", @"21", @"23", @"22", @"26", @"28", @"25", nil];
        }

        NSUInteger tabIndex = [keyCode2TabIndex indexOfObject:[[NSNumber numberWithInt:event.keyCode] stringValue]];

        if (tabIndex != NSNotFound)
        {
            NSWindow *keyWindow = [[NSApplication sharedApplication] keyWindow];

            if ([keyWindow respondsToSelector:@selector(orderedTabViewItems)] // check safari API compat
                && [keyWindow respondsToSelector:@selector(setCurrentTabViewItem:)])
            {
                NSArray *tabs = [keyWindow performSelector:@selector(orderedTabViewItems)];
                NSInteger newTabIndex = -1;
                
                if (tabIndex == 8)
                {
                    newTabIndex = tabs.count - 1;
                }
                else if (tabs.count >= (tabIndex + 1))
                {
                    newTabIndex = tabIndex;
                }
                
                if (newTabIndex >= 0)
                {
                    [keyWindow performSelector:@selector(setCurrentTabViewItem:) withObject:[tabs objectAtIndex:newTabIndex]];
                }
                    
                return; // prevent event dispatching
            }
        }
        
    }
    else if (event.type == NSKeyDown
             && (event.modifierFlags & NSDeviceIndependentModifierFlagsMask) == (NSCommandKeyMask|NSShiftKeyMask) && event.keyCode == 0x11) { // keycode of 'T'

        CGEventRef e = CGEventCreateKeyboardEvent(NULL, 0x6, YES); // keycode of 'Z'
        
        CGEventSetFlags(e, kCGEventFlagMaskCommand);
        
        NSEvent *new_event = [NSEvent eventWithCGEvent:e];
        
        CFRelease(e);
        
        [self SafariTabeSwitching_sendEvent:new_event];
        
        return;
    }

    [self SafariTabeSwitching_sendEvent:event];
}

@end

@implementation SafariTabSwitching
@dynamic pluginVersion;

+ (NSString *)pluginVersion
{
    return [[[NSBundle bundleForClass:self] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (void)load
{
    NSLog(@"Safari Tab Switching %@ Loaded", self.pluginVersion);
    [NSClassFromString(@"BrowserApplication") jr_swizzleMethod:@selector(sendEvent:) withMethod:@selector(SafariTabeSwitching_sendEvent:) error:NULL];

}

@end
