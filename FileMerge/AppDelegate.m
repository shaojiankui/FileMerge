//
//  AppDelegate.m
//  FileMerge
//
//  Created by Jakey on 2017/5/30.
//  Copyright © 2017年 Jakey. All rights reserved.
//

#import "AppDelegate.h"
#import "FileDragView.h"
@interface AppDelegate ()
{
    NSMutableArray *_files;
}
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _files = [NSMutableArray array];
    FileDragView *dragView = self.window.contentView;
    
    __weak typeof(self) weakSelf = self;
    
    [dragView didDragEndBlock:^(NSArray *result) {
        NSLog(@"%@",result);
        [_files addObjectsFromArray:result];
        [weakSelf.tableView reloadData];
    }];
    
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
#pragma mark - NSTableViewDataSource, NSTableViewDelegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [_files count];
}
-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSString *file = [_files objectAtIndex:row];
    
    NSString *identifier = [tableColumn identifier];
    if([identifier isEqualToString:@"name"]){
        return [file lastPathComponent];
    }
    if([identifier isEqualToString:@"path"]){
        return file;
    }
    return file;
}

-(void)tableView:(NSTableView *)tableView mouseDownInHeaderOfTableColumn:(NSTableColumn *)tableColumn{
//    NSImage *indicatorImage;
//    if (sortAscending) {
//        indicatorImage = [NSImage imageNamed: @"NSAscendingSortIndicator"];
//    } else {
//        indicatorImage = [NSImage imageNamed: @"NSDescendingSortIndicator"];
//    }
//    sortAscending = !sortAscending;
//    
//    [tableView setIndicatorImage: indicatorImage
//                   inTableColumn: tableColumn];
//    
//    [tableView reloadData];
    
    
//    
}
- (NSDragOperation) tableView: (NSTableView *) view
                 validateDrop: (id ) info
                  proposedRow: (int) row
        proposedDropOperation: (NSTableViewDropOperation) op
{
    [view setDropRow: row
       dropOperation: op];
    
    NSDragOperation dragOp = NSDragOperationCopy;
    
    return (dragOp);
    
}

- (IBAction)mergeTouched:(id)sender {
    NSSavePanel*    panel = [NSSavePanel savePanel];
    [panel setNameFieldStringValue:@"Untitle"];
    [panel setMessage:@"Choose the path to save the document"];
    [panel setAllowsOtherFileTypes:YES];
//    [panel setAllowedFileTypes:@[@"onecodego"]];
    [panel setExtensionHidden:YES];
    [panel setCanCreateDirectories:YES];
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton)
        {
            NSString *path = [[panel URL] path];
            [self mergeFiles:path];
        }
        
    }];
}
-(void)mergeFiles:(NSString*)savePath{
//    Jakey-Pro:Downloads jakey$ cat x0019in109q.p209.* > x0019in109q.mp4


}

- (IBAction)resetTouched:(id)sender {
    [_files removeAllObjects];
    [self.tableView reloadData];
}
@end
