//
//  ChatTableViewCell.m
//  MatchaChat
//
//  Created by Joshua Zhou on 14/11/26.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "AppDelegate.h"

@interface ChatTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMessageButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMessageButtonWidth;

@end

@implementation ChatTableViewCell

- (AppDelegate *)appDelegate
{
    return [UIApplication sharedApplication].delegate;
}

+ (instancetype)cellForTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier
{
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    cell.iconView.layer.cornerRadius = 5.0;
    cell.iconView.clipsToBounds = YES;
    
    return cell;
}

- (void)setModel:(XMPPMessageArchiving_Message_CoreDataObject *)model
{
    _model = model;
    
    NSData *photoData = nil;
    if (model.isOutgoing) {
        photoData = [[[self appDelegate] xmppvCardAvatarModule] photoDataForJID:[XMPPJID jidWithString:model.streamBareJidStr]];
    } else {
        photoData = [[[self appDelegate] xmppvCardAvatarModule] photoDataForJID:model.bareJid];
    }
    self.iconView.image = [UIImage imageWithData:photoData];
    
    CGSize textSize = [model.body boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.messageButton.titleLabel.font} context:nil].size; // 别忘了attribute里面要填字体，这里浪费了我一个早上和一个下午
    self.constraintMessageButtonHeight.constant = textSize.height + 32;
    self.constraintMessageButtonWidth.constant = textSize.width + 40;

    [self.messageButton setTitle:model.body forState:UIControlStateNormal];
    
    [self.messageButton layoutIfNeeded];
}

@end
