//
//  ContactsTableViewCell.m
//  MatchaChat
//
//  Created by Joshua Zhou on 14/11/20.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "ContactsTableViewCell.h"

@interface ContactsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;

@end

@implementation ContactsTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView AndReuseIdentifier:(NSString *)reuseIdentifier
{
    ContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[ContactsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    return cell;
}

- (void)setModel:(XMPPUserCoreDataStorageObject *)model
{
    _model = model;
    
    self.iconView.image = model.photo;
    self.contactNameLabel.text = model.displayName;
}

@end
