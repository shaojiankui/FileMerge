//
//  AppDelegate.h
//  FileMerge
//
//  Created by Jakey on 2017/5/30.
//  Copyright © 2017年 Jakey. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSTableView *tableView;

- (IBAction)mergeTouched:(id)sender;
- (IBAction)resetTouched:(id)sender;
@end

