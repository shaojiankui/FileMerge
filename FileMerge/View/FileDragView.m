//
//  FileDragView.m
//  FileMerge
//
//  Created by Jakey on 2017/5/30.
//  Copyright © 2017年 Jakey. All rights reserved.
//

#import "FileDragView.h"

@implementation FileDragView
{
    BOOL isDragIn;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];

}
- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    if (isDragIn)
    {
        NSColor* color = [NSColor colorWithRed:220.0 / 255 green:220.0 / 255 blue:220.0 / 255 alpha:1.0];
        [color set];
        NSBezierPath* thePath = [NSBezierPath bezierPath];
        [thePath appendBezierPathWithRoundedRect:dirtyRect xRadius:8.0 yRadius:8.0];
        [thePath fill];
    }
}

#pragma mark - Destination Operations

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    isDragIn = YES;
    [self setNeedsDisplay:YES];
    NSPasteboard *zPasteboard = [sender draggingPasteboard];
    NSArray *list = [zPasteboard propertyListForType:NSFilenamesPboardType];
    if(_didDragEnd){
        _didDragEnd(list);
    }
    return NSDragOperationCopy;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender
{
    isDragIn = NO;
    [self setNeedsDisplay:YES];
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender
{
    isDragIn = NO;
    [self setNeedsDisplay:YES];
    return YES;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    if ([sender draggingSource] != self)
    {
        NSArray* filePaths = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
        NSLog(@"hahaha");
    }
    
    return YES;
}
-(void)didDragEndBlock:(DidDragEnd)didDragEnd{
    _didDragEnd = [didDragEnd copy];
}
@end
