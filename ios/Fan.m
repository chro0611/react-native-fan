#import "Fan.h"
#import "ExUnversioned.h"

#import <React/RCTUtils.h>
#import <FBAudienceNetwork/FBAudienceNetwork.h>

@interface FanManager () <FBInterstitialAdDelegate>

@property (nonatomic, strong) FBInterstitialAd *interstitialAd;
@property (nonatomic, strong) RCTPromiseResolveBlock loadResolve;
@property (nonatomic, strong) RCTPromiseRejectBlock loadReject;
@property (nonatomic, strong) RCTPromiseResolveBlock showResolve;
@property (nonatomic, strong) RCTPromiseRejectBlock showReject;
@property (nonatomic, strong) UIViewController *adViewController;
@property (nonatomic) bool didClick;
@property (nonatomic) bool isBackground;
@property (nonatomic) bool loaded;
@property (nonatomic) NSString *placementId;

@end

@implementation FanManager

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE(Fan)

- (void)setBridge:(RCTBridge *)bridge
{
  _bridge = bridge;
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(bridgeDidForeground:)
                                               name:EX_UNVERSIONED(@"EXKernelBridgeDidForegroundNotification")
                                             object:self.bridge];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(bridgeDidBackground:)
                                               name:EX_UNVERSIONED(@"EXKernelBridgeDidBackgroundNotification")
                                             object:self.bridge];
}

RCT_EXPORT_METHOD(
                  isLoad:(RCTPromiseResolveBlock)resolve
                  isLoadRejector:(RCTPromiseRejectBlock)reject
)
{
    resolve(@(_loaded));
}

RCT_EXPORT_METHOD(
                  loadAd:(NSString *)placementId
                  loadAdResolver:(RCTPromiseResolveBlock)resolve
                  loadAdRejector:(RCTPromiseRejectBlock)reject
                  )
{
  _placementId = [NSString stringWithFormat:@"%@#%@", @"VID_HD_9_16_39S_APP_INSTALL", placementId];

  _loadResolve = resolve;
  _loadReject = reject;
  
  _interstitialAd = [[FBInterstitialAd alloc] initWithPlacementID:_placementId];
  __block FBInterstitialAd *interstital = _interstitialAd;

  void (^runLoad)(void) = ^(void) {
    interstital.delegate = self;
    [interstital loadAd];
  };
    
  dispatch_queue_t mainQueue = dispatch_get_main_queue();
  dispatch_async(mainQueue, runLoad);
}

RCT_EXPORT_METHOD(
                  showAd:(RCTPromiseResolveBlock)resolve
                  showAdRejector:(RCTPromiseRejectBlock)reject
                  )
{
    _showResolve = resolve;
    _showReject = reject;
    
    __block FBInterstitialAd *interstital = _interstitialAd;
    __block UIViewController *view = RCTPresentedViewController();
    
    void (^runShow)(void) = ^(void) {
        NSLog(@"on main queue!");
        if(interstital && interstital.isAdValid)
        {
            [interstital showAdFromRootViewController:view];
        }
    };
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, runShow);
}

- (void)cleanUp
{
    _showResolve = nil;
    _showReject = nil;
    _loadResolve = nil;
    _loadReject = nil;
    _interstitialAd = nil;
    _adViewController = nil;
    _didClick = false;
    _isBackground = false;
    _loaded = false;
}

- (void)interstitialAd:(FBInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    _loadReject(@"E_FAILED_TO_LOAD", [error localizedDescription], error);
    [self cleanUp];
}

- (void)interstitialAdDidLoad:(FBInterstitialAd *)interstitialAd
{
    if (_interstitialAd && _interstitialAd.isAdValid) {
        _loaded = true;
        _loadResolve(@(_loaded));
    }
}

- (void)interstitialAdDidClick:(FBInterstitialAd *)interstitialAd
{
    _didClick = true;
}

- (void)interstitialAdDidClose:(FBInterstitialAd *)interstitialAd
{
    _showResolve(@(_didClick));
    [self cleanUp];
}

- (void)bridgeDidForeground:(NSNotification *)notification
{
  _isBackground = false;
  
  if (_adViewController) {
    [RCTPresentedViewController() presentViewController:_adViewController animated:NO completion:nil];
    _adViewController = nil;
  }
}

- (void)bridgeDidBackground:(NSNotification *)notification
{
  _isBackground = true;
  
  if (_interstitialAd) {
    _adViewController = RCTPresentedViewController();
    [_adViewController dismissViewControllerAnimated:NO completion:nil];
  }
}

@end
