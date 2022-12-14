#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(TurboViewManager, RCTViewManager)
    RCT_EXPORT_VIEW_PROPERTY(sessionKey, NSString);
    RCT_EXPORT_VIEW_PROPERTY(url, NSURL);
    RCT_EXPORT_VIEW_PROPERTY(onProposeVisit, RCTBubblingEventBlock)
    RCT_EXTERN_METHOD(reload:(nonnull NSNumber *)reactTag)
@end
