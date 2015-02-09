//
//  ChatViewController.m
//  MatchaChat
//
//  Created by Joshua Zhou on 14/11/25.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "ChatViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "ChatTableViewCell.h"
#import "JZEmotionKeyboard.h"
#import "JZFunctionPickerView.h"

@interface ChatViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, JZEmotionKeyboardDelegate, JZFunctionPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (nonatomic, strong) NSFetchedResultsController *fetchResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChatViewController

- (AppDelegate *)appDelegate
{
    return [UIApplication sharedApplication].delegate;
}

- (NSFetchedResultsController *)fetchResultsController
{
    if (!_fetchResultsController)
    {
        NSManagedObjectContext *context = [[[self appDelegate] xmppMessageArchivingCoreDataStorage] mainThreadManagedObjectContext];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
        request.sortDescriptors = @[sortDescriptor];
        request.predicate = [NSPredicate predicateWithFormat:@"bareJidStr = 'admin1@virus-found.local' AND streamBareJidStr = 'admin2@virus-found.local'"];
        _fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        _fetchResultsController.delegate = self;
        
        NSError *error = nil;
        [_fetchResultsController performFetch:&error];
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }
    return _fetchResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
    [self scrollToBottomOfTableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.headline;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self scrollToBottomOfTableView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGFloat beginY= [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].origin.y;
    CGFloat endY = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];

    [UIView animateWithDuration:animationDuration animations:^{
        self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, endY - beginY);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.view.transform = CGAffineTransformIdentity;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:@"admin1@virus-found.local"]]; // 与presence的type一样
    [message addBody:textField.text];
    [[[self appDelegate] xmppStream] sendElement:message];
    textField.text = nil;
    [self scrollToBottomOfTableView];
    return YES;
}

- (void)scrollToBottomOfTableView
{
    id <NSFetchedResultsSectionInfo> info = [self.fetchResultsController.sections firstObject]; // 因为我们只有一个section，所以第一个就行了
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[info numberOfObjects] - 1 inSection:0];
  //  [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> info = self.fetchResultsController.sections[section];
    return [info numberOfObjects];
}

- (ChatTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPMessageArchiving_Message_CoreDataObject *object = [self.fetchResultsController objectAtIndexPath:indexPath];
    
    NSString *reuseIdentifier = (object.isOutgoing)?@"My message cell":@"Others message cell";
    ChatTableViewCell *cell = [ChatTableViewCell cellForTableView:tableView reuseIdentifier:reuseIdentifier];
    cell.model = object;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPMessageArchiving_Message_CoreDataObject *object = [self.fetchResultsController objectAtIndexPath:indexPath];
    CGSize textSize = [object.body boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]} context:nil].size;
    if (textSize.height + 32 > 70) {
        return textSize.height + 32;
    }
    
    return 70;
}

#pragma mark - 输入工具栏按钮处理
- (IBAction)clickEmotionButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        JZEmotionKeyboard *emotionKeyboard = [[JZEmotionKeyboard alloc] initWithFrame:CGRectMake(0, 0, 100, 216)];  // 从Notification知道键盘高度是216
        emotionKeyboard.delegate = self;
        self.inputTextField.inputView = emotionKeyboard;
    } else {
        self.inputTextField.inputView = nil;  // 还原键盘
    }
    [self.inputTextField reloadInputViews];
    [self.inputTextField becomeFirstResponder];
}

- (IBAction)clickMoreButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        JZFunctionPickerView *pickerView = [[JZFunctionPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 216)];
        pickerView.delegate = self;
        self.inputTextField.inputView = pickerView;
    } else {
        self.inputTextField.inputView = nil;
    }
    [self.inputTextField reloadInputViews];
    [self.inputTextField becomeFirstResponder];
}

- (void)emotionKeyboard:(JZEmotionKeyboard *)emotionKeyboard didPickEmotion:(NSString *)emotion
{
    self.inputTextField.text = [NSString stringWithFormat:@"%@%@", self.inputTextField.text, emotion]; // 应该依据光标位置而改变
}

- (void)emotionKeyboardDidDeleteEmotion:(JZEmotionKeyboard *)emotionKeyboard
{
    self.inputTextField.text = [self.inputTextField.text substringToIndex:([self.inputTextField.text length] - 1)];
}

- (void)functionPickerView:(JZFunctionPickerView *)functionPickerView didPickFunction:(JZFunctionPickerViewFunctionType)type
{
    switch (type) {
        case JZFunctionPickerViewFunctionTypePhoto:
            [self pickImage];
            break;
    }
}

#pragma mark - UIImagePickerViewDelegate
- (void)pickImage
{
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    [actionSheetController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:ipc animated:YES completion:nil];
    }]];
    [actionSheetController addAction:[UIAlertAction actionWithTitle:@"从照片中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:ipc animated:YES completion:nil];
    }]];
    [actionSheetController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    ipc.delegate = self;
    [self presentViewController:actionSheetController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
