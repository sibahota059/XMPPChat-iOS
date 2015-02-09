//
//  ContactsTableViewCell.h
//  MatchaChat
//
//  Created by Joshua Zhou on 14/11/20.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ContactsTableViewCell : UITableViewCell

@property (nonatomic, strong) XMPPUserCoreDataStorageObject *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView AndReuseIdentifier:(NSString *)reuseIdentifier;

@end
