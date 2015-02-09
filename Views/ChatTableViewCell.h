//
//  ChatTableViewCell.h
//  MatchaChat
//
//  Created by Joshua Zhou on 14/11/26.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPMessageArchiving_Message_CoreDataObject.h"
#import "XMPPvCardAvatarModule.h"

@interface ChatTableViewCell : UITableViewCell

@property (nonatomic, strong) XMPPMessageArchiving_Message_CoreDataObject *model;

+ (instancetype)cellForTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;

@end
