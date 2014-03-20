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
    NSButton *close = [self.window standardWindowButton:NSWindowCloseButton];
    [close setTarget:self];
    [close setAction:@selector(quit)];
    
}
- (void)quit{
    [[NSApplication sharedApplication] terminate:nil];
}
- (void)awakeFromNib{
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
    [self adjustSettings];
}
- (void) adjustSettings{
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
- (BOOL) allSettingsSaved{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *command = [userDefaults stringForKey:@"command"];
     NSString *app = [userDefaults stringForKey:@"appName"];
    return (command != nil && app != nil && ![command isEqualToString:@""] && ![app isEqualToString:@""]);
    
}
- (void)launchURLwithURL:(NSString *)url{
    NSLog(@"here");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *command = [userDefaults stringForKey:@"command"];
    NSString *app = [userDefaults stringForKey:@"appName"];
    NSLog(@"'%@'",command);
    if ([app isEqualToString:@"iTerm"]) {
        NSString *filepath = [[NSBundle mainBundle] pathForResource:@"iterm" ofType:@"applescript"];
        NSString *applescript = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
        NSString *newcommand = [NSString stringWithFormat:@"%@ %@",command,url];
        NSString *newApplescript = [applescript stringByReplacingOccurrencesOfString:@"IRC_COMMAND_PLACEHOLDER"
                                                                          withString:newcommand];
        NSLog(@"Connecting to %@",url);
        NSAppleScript *apple = [[NSAppleScript alloc]initWithSource:newApplescript];
        [apple executeAndReturnError:nil];
    }

}
- (void)handleURLEvent:(NSAppleEventDescriptor*)event withReplyEvent:(NSAppleEventDescriptor*)replyEvent
{
    self.window.isVisible = NO;
    if (![self allSettingsSaved]) {
        self.saveButton.title = @"Save and Run";

        self.urlevent = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
        [self adjustSettings];
    } else{
        [self launchURLwithURL:[[event paramDescriptorForKeyword:keyDirectObject] stringValue]];
    }
}
- (void) alert{
    [[NSAlert alertWithMessageText:@"Alert" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please fill out all forms"] runModal];
    
}
- (IBAction)saveSettings:(id)sender {
    if (([self.AppName selectedItem] != nil && [self.ircProgram stringValue] != nil && ![self.ircProgram.stringValue isEqualToString:@""]) || NO) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[[self.AppName selectedItem] title] forKey:@"appName"];
        [userDefaults setObject:[self.ircProgram stringValue] forKey:@"command"];
        [userDefaults synchronize];
        if (self.urlevent != nil) {
            [self launchURLwithURL:self.urlevent];
        }
        [[NSApplication sharedApplication] terminate:nil];
    } else {
        [self alert];
    }
}

@end
