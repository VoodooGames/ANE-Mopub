//
//  OperaBannerCustomEvent.m
//
//  Copyright (c) 2016 Voodoo All rights reserved.
//

#import "OperaBannerCustomEvent.h"
#import "MPInstanceProvider.h"
#import "MPConstants.h"
#import "MPLogging.h"
#import "AdMarvelView.h"


@interface OperaBannerCustomEvent ()

@property (nonatomic, retain) AdMarvelView *adMarvelBanner;
@property (nonatomic) CGSize bannerSize;
@property (nonatomic, strong) NSString *partnerId;
@property (nonatomic, strong) NSString *siteId;

@end

@implementation OperaBannerCustomEvent

#pragma mark - MPBannerCustomEvent Subclass Methods

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info {
    MPLogInfo(@"Requesting an Opera banner ...");

    // Get the required IDs
    self.partnerId = info[@"pid"];
    self.siteId = info[@"sid"];

    if(!self.partnerId || !self.siteId) {
        MPLogError(@"Invalid partnerId (%@) or siteId (%@)!", self.partnerId, self.siteId);
        [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:nil];
    }
    
    // Create the banner :
    self.bannerSize = size;
    self.adMarvelBanner = [AdMarvelView createAdMarvelViewWithDelegate:self];
    
    [self.adMarvelBanner getAdWithNotification];
    
}





#pragma mark - Delegate implementation

- (NSString *)partnerId:(AdMarvelView *)AdMarvelView {
    return self.partnerId;
}

- (NSString *)siteId:(AdMarvelView *)AdMarvelView {
    return self.siteId;
}

- (UIViewController *)applicationUIViewController:(AdMarvelView *)AdMarvelView {
    // Mopub cares about displaying the banner, passing nil as the application view controller.
    return nil;
}

- (CGRect)adMarvelViewFrame:(AdMarvelView *)adMarvelView {
    return CGRectMake(0, 0, self.bannerSize.width, self.bannerSize.height);
}


- (BOOL)testingEnabled:(AdMarvelView *)adMarvelView {
    return NO;
}


- (void) fullScreenWebViewActivated:(AdMarvelView *)adMarvelView {
    MPLogInfo(@"Opera Mediaworks banner will present modal");
    [self.delegate bannerCustomEventWillBeginAction:self];
}

- (void) fullScreenWebViewClosed:(AdMarvelView *)adMarvelView {
    MPLogInfo(@"Opera Madiaworks banner did close");
    [self.delegate bannerCustomEventDidFinishAction:self];
}

- (void) getAdSucceeded:(AdMarvelView *)adMarvelView {
    MPLogInfo(@"Opera Mediaworks banner did load");
    [self.delegate trackImpression];
    [self.delegate bannerCustomEvent:self didLoadAd:adMarvelView];
}

- (void) getAdFailed:(AdMarvelView *)adMarvelView {
    MPLogInfo(@"Opera Mediaworks banner did fail to load!");
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:nil];    // -> no error is provided by Opera mediaworks
}

- (void) adDidExpand:(AdMarvelView *)adMarvelView {
    NSLog(@"Opera Mediaworks ad did expand!");
}

- (void) adDidCollapse:(AdMarvelView *)adMarvelView {
    NSLog(@"Opera Mediaworks banner ad did collapse!");
}

- (void) adMarvelViewWasClicked:(AdMarvelView *)adMarvelView {
    MPLogInfo(@"Opera Mediaworks banner was clicked");
    [self.delegate trackClick];
}

- (void) handleAdMarvelSDKClick:(NSString *)urlString forAdMarvelView:(AdMarvelView *)adMarvelView {
    MPLogInfo(@"Opera Mediaworks banner was clicked");
    [self.delegate trackClick];
}




- (void)dealloc {
    [self.adMarvelBanner setDelegate:nil];
    self.adMarvelBanner = nil;

    self.partnerId = nil;
    self.siteId = nil;
}

@end
