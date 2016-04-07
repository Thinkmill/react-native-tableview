//
//  RNReactModuleCell.m
//  RNTableView
//
//  Created by Anna Berman on 2/6/16.
//  Copyright © 2016 Pavlo Aksonov. All rights reserved.
//

#import <RCTRootView.h>
#import "RNReactModuleCell.h"

@implementation RNReactModuleCell {
    RCTRootView *_rootView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier bridge:(RCTBridge*) bridge data:(NSDictionary*)data indexPath:(NSIndexPath*)indexPath reactModule:(NSString*)reactModule
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpAndConfigure:data bridge:bridge indexPath:indexPath reactModule:reactModule];
    }
    return self;
}

-(NSDictionary*) toProps:(NSDictionary *)data indexPath:(NSIndexPath*)indexPath {
    return @{@"data":data, @"section":[[NSNumber alloc] initWithLong:indexPath.section], @"row":[[NSNumber alloc] initWithLong:indexPath.row]};
}

-(void)setUpAndConfigure:(NSDictionary*)data bridge:(RCTBridge*)bridge indexPath:(NSIndexPath*)indexPath reactModule:(NSString*)reactModule{
    NSDictionary *props = [self toProps:data indexPath:indexPath];
    if (_rootView == nil) {
        //Create the mini react app that will populate our cell. This will be called from cellForRowAtIndexPath
        _rootView = [[RCTRootView alloc] initWithBridge:bridge moduleName:reactModule initialProperties:props];
        [self.contentView addSubview:_rootView];
        _rootView.frame = self.contentView.frame;
        _rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    } else {
        //Ask react to re-render us with new data
        _rootView.appProperties = props;
    }
    //The application will be unmounted in javascript when the cell/rootview is destroyed
}

-(void)prepareForReuse {
    [super prepareForReuse];
    //TODO prevent stale data flickering
}

@end
