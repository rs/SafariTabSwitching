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

        if (tabIndex != NSNotFound
            && [[NSApplication sharedApplication] respondsToSelector:@selector(frontWindow)]) // check safari API compat
        {
            NSWindow *frontWindow = [[NSApplication sharedApplication] performSelector:@selector(frontWindow)];

            if ([frontWindow respondsToSelector:@selector(orderedTabViewItems)] // check safari API compat
                && [frontWindow respondsToSelector:@selector(setCurrentTabViewItem:)])
            {
                NSArray *tabs = [frontWindow performSelector:@selector(orderedTabViewItems)];
                if (tabs.count >= (tabIndex + 1))
                {
                    [frontWindow performSelector:@selector(setCurrentTabViewItem:) withObject:[tabs objectAtIndex:tabIndex]];
                }
                return; // prevent event dispatching
            }
        }
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
