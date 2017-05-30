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
    [self.tableView registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];

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
    [_files sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
//    
}

- (IBAction)mergeTouched:(id)sender {
    NSString *ext = [[_files firstObject] pathExtension];
    NSSavePanel*    panel = [NSSavePanel savePanel];
    [panel setNameFieldStringValue:[@"Untitle" stringByAppendingPathExtension:ext?:@""]];
    [panel setMessage:@"Choose the path to save the document"];
    [panel setAllowsOtherFileTypes:YES];
//    [panel setAllowedFileTypes:@[@"onecodego"]];
    [panel setExtensionHidden:NO];
    [panel setCanCreateDirectories:YES];
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton)
        {
            NSString *path = [[panel URL] path];
            [panel close];
            [self mergeFiles:path];
        }
        
    }];
}
-(void)mergeFiles:(NSString*)savePath{
//    Jakey-Pro:Downloads jakey$ cat x0019in109q.p209.* > x0019in109q.mp4
    
    
    [self merge:savePath files:_files];
    
}

-(void)merge:(NSString *)destination files:(NSArray *)files {
    [[NSFileManager defaultManager] createFileAtPath:destination contents:nil attributes:nil];

    NSFileHandle *writerHandle = [NSFileHandle fileHandleForWritingAtPath:destination];
    [writerHandle seekToFileOffset:0];
    unsigned long long chunkSize = 50*1024*1024;
    
    for (NSString *file in files) {
        NSFileHandle *readerHandle = [NSFileHandle fileHandleForReadingAtPath:file];
        NSData *data =  [readerHandle readDataOfLength:chunkSize];
        NSLog(@"merging file:%@",[file lastPathComponent]);
        while ([data length]>0) {
            [writerHandle writeData:data];
            data = [readerHandle readDataOfLength:chunkSize];
        }
        [readerHandle closeFile];
    }
    [writerHandle closeFile];
}

- (IBAction)resetTouched:(id)sender {
    [_files removeAllObjects];
    [self.tableView reloadData];
}
@end
