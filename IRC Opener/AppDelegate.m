//
//  AppDelegate.m
//  IRC Opener
//
//  Created by Sean Brody on 3/19/14.
//  Copyright (c) 2014 Sean Brody. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(handleURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
    
    }
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
    self.window.isVisible = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *command = [userDefaults stringForKey:@"command"];
    if (command != nil){
        [self.ircProgram setStringValue:command];
    }
    NSString *app = [userDefaults stringForKey:@"appName"];
    if (app != nil) {
        NSArray *appList = [self.AppName itemArray];
        for (NSMenuItem *item in appList){
            if ([item.title isEqualToString:app]){
                [self.AppName selectItem:item];
            }
        }
    }
    [self.AppName setAutoenablesItems:NO];
    
}
- (void)handleURLEvent:(NSAppleEventDescriptor*)event withReplyEvent:(NSAppleEventDescriptor*)replyEvent
{
    NSString* url = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"iterm" ofType:@"applescript"];
    NSString *applescript = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    NSString *newcommand = [NSString stringWithFormat:@"/usr/local/bin/weechat-curses %@",url];
    NSString *newApplescript = [applescript stringByReplacingOccurrencesOfString:@"IRC_COMMAND_PLACEHOLDER"
                                                                      withString:newcommand];
    NSLog(@"Connecting to %@",url);
    NSAppleScript *apple = [[NSAppleScript alloc]initWithSource:newApplescript];
    [apple executeAndReturnError:nil];
    [[NSApplication sharedApplication] terminate:nil];
    }
- (IBAction)saveSettings:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[[self.AppName selectedItem] title] forKey:@"appName"];
    [userDefaults setObject:[self.ircProgram stringValue] forKey:@"command"];
    [userDefaults synchronize];
}

@end
