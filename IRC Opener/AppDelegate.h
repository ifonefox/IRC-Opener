//
//  AppDelegate.h
//  IRC Opener
//
//  Created by Sean Brody on 3/19/14.
//  Copyright (c) 2014 Sean Brody. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSPopUpButton *AppName;
@property (weak) IBOutlet NSTextField *ircProgram;

@end
