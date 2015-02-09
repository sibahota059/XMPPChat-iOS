

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"

typedef void(^CompletionBlock)(NSString *message);
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong) XMPPRoster *xmppRoster;
@property (nonatomic, strong) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchiving;
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;

@property (nonatomic, assign, getter=isRegistered) BOOL registration;

- (void)connectWithAccountName:(NSString *)accountName Password:(NSString *)password ServerName:(NSString *)serverName Success:(CompletionBlock)success Failure:(CompletionBlock)failure;

@end

