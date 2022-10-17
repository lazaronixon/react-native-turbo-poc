#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(TurboViewManager, RCTViewManager)
    RCT_EXPORT_VIEW_PROPERTY(sessionKey, NSString);
    RCT_EXPORT_VIEW_PROPERTY(url, NSURL);
    RCT_EXPORT_VIEW_PROPERTY(onProposeVisit, RCTBubblingEventBlock)
    RCT_EXTERN_METHOD(viewWillAppear:(nonnull NSNumber *)reactTag)
    RCT_EXTERN_METHOD(viewDidAppear:(nonnull NSNumber *)reactTag)
@end
