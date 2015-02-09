

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPvCardTempModule.h"

@interface AppDelegate () <XMPPStreamDelegate, XMPPRosterDelegate>

@property (nonatomic, strong) CompletionBlock success;
@property (nonatomic, strong) CompletionBlock failure;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) XMPPCapabilities *xmppCapabilities;

@end

@implementation AppDelegate

#pragma mark - AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
  
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    ((UITabBarItem *)tabBarController.tabBar.items[0]).selectedImage = [UIImage imageNamed:@"tabbar_mainframeHL"];
    ((UITabBarItem *)tabBarController.tabBar.items[1]).selectedImage = [UIImage imageNamed:@"tabbar_contactsHL"];
    ((UITabBarItem *)tabBarController.tabBar.items[2]).selectedImage = [UIImage imageNamed:@"tabbar_meHL"];
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewControllerView" bundle:[NSBundle mainBundle]];
    [self.window setRootViewController:loginVC];
    
   
    [self setupXMPPStream];
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    [self disconnectFromServer];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //    [self connectToServer];
    //    [self connectWithAccountName:@"joshua" Password:@"123456" ServerName:@"xxx" Success:nil Failure:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self disconnectFromServer];
}

- (void)dealloc
{
    [self teardownStream];
}

#pragma mark - XMPP

- (void)setupXMPPStream
{
    NSAssert(_xmppStream == nil, @"nil");
    _xmppStream = [[XMPPStream alloc] init];
    _xmppReconnect = [[XMPPReconnect alloc] init];
    [_xmppReconnect activate:_xmppStream];
    
    _xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:[XMPPvCardCoreDataStorage sharedInstance]];
    
    _xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_xmppvCardTempModule];
    [_xmppvCardTempModule activate:_xmppStream];
    [_xmppvCardAvatarModule activate:_xmppStream];
    
    _xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterStorage];
    [_xmppRoster setAutoAcceptKnownPresenceSubscriptionRequests:YES];
    [_xmppRoster setAutoFetchRoster:YES];
    [_xmppRoster activate:_xmppStream];
    
    _xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:[[XMPPCapabilitiesCoreDataStorage alloc] init]];
    [_xmppCapabilities activate:_xmppStream];
    _xmppMessageArchivingCoreDataStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    _xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage];
    [_xmppMessageArchiving activate:_xmppStream];
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

//- (void)connectToServer
//{
//    NSString *accountName = @"joshua@joshuas-macbook-pro.local";
//    NSString *hostName = @"joshuas-macbook-pro.local";
//
//    [_xmppStream setMyJID:[XMPPJID jidWithString:accountName]];
//    [_xmppStream setHostName:hostName];
//
//    NSError *error = nil;
//    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
//    if (error) {
//        NSLog(@"Error : %@", error.localizedDescription);
//    }
//}

- (void)disconnectFromServer
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:presence];
    [_xmppStream disconnect];

}

- (void)teardownStream
{
    [_xmppStream removeDelegate:self];
    [_xmppRoster removeDelegate:self];

    [_xmppReconnect deactivate];
    [_xmppvCardTempModule deactivate];
    [_xmppRoster deactivate];
    [_xmppCapabilities deactivate];
    [_xmppvCardAvatarModule deactivate];
    [_xmppMessageArchiving deactivate];
    
    [_xmppStream disconnect];
    
    _xmppStream = nil;
    _xmppReconnect = nil;
    _xmppvCardTempModule = nil;
    _xmppRoster = nil;
    _xmppRosterStorage = nil;
    _xmppCapabilities = nil;
    _xmppvCardAvatarModule = nil;
    _xmppMessageArchiving = nil;
    _xmppMessageArchivingCoreDataStorage = nil;
}

#pragma mark - XMPPStream Delegate
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
   
    self.password = @"Agent456";
    
    NSError *error = nil;
    if (!self.isRegistered) {
        [_xmppStream authenticateWithPassword:self.password error:&error];
    } else {
        [_xmppStream registerWithPassword:self.password error:&error];
    }
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    XMPPPresence *presence = [XMPPPresence presence];
    [_xmppStream sendElement:presence];
    
    self.success(@"Success！");
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    
    self.failure(@"Failed！");
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    self.registration = NO;
    
    self.success(@"Success！");
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:nil];
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    self.registration = NO;
    
   self.failure(@"Failed！");
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"%@", message);
}

- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    
    if ([presence.type isEqualToString:@"subscribe"]) {
        XMPPJID *from = [presence from];
        [_xmppRoster acceptPresenceSubscriptionRequestFrom:from andAddToRoster:YES];
    }
}

#pragma mark - Connect

- (void)connectWithAccountName:(NSString *)accountName Password:(NSString *)password ServerName:(NSString *)serverName Success:(CompletionBlock)success Failure:(CompletionBlock)failure
{
    if ([_xmppStream isConnected]) return;  //    if (![_xmppStream isDisconnected])   return;
    
    self.password = password;
    serverName = @"virus-found.local";
    accountName = [accountName stringByAppendingString:[NSString stringWithFormat:@"@%@", serverName]];
    
    [_xmppStream setMyJID:[XMPPJID jidWithString:accountName]];
    [_xmppStream setHostName:serverName];
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:nil];
    
    self.success = success;
    self.failure = failure;
}
 //virus-found.local admin  Agent456

@end
