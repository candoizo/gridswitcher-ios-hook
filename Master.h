@interface UIApplication (Private)
-(void)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end

@interface SBMainSwitcherViewController : UIViewController
+(id)sharedInstance;
-(void)_quitAppRepresentedByDisplayItem:(id)arg1 forReason:(long long)arg2 ;
@end

// @interface _UIBackdropView : UIView
// -(id)initWithFrame:(id)arg1 style:(int)arg2;
// @end

@interface SBDisplayItem : NSObject
@property (nonatomic,copy,readonly) NSString * displayIdentifier;
+(id)displayItemWithType:(NSString*)arg1 displayIdentifier:(id)arg2 ;
+(id)homeScreenDisplayItem;
@end

@interface SBAppSwitcherModel : NSObject
+(id)sharedInstance;
@end

@interface SBSwitcherContainerView : UIView
@end

@interface SBApplication : NSObject
-(NSString *)displayName;
-(NSString *)bundleIdentifier;
@end

@interface SBAppSwitcherSnapshotView : UIView
@property () SBApplication * application;
-(void)_setCornerRadiusIfNecessaryForSnapshotImageView:(id)arg1 ;
- (void)_loadSnapshotAsyncPreferringDownscaled:(_Bool)arg1;
+ (id)appSwitcherSnapshotViewForDisplayItem:(id)arg1 orientation:(long long)arg2 preferringDownscaledSnapshot:(_Bool)arg3 loadAsync:(_Bool)arg4 withQueue:(dispatch_queue_t)arg5;
@end

@interface SBCloseBoxView : UIView

@end

@interface SBApplicationIcon : UIView
-(id)initWithApplication:(id)arg1 ;
-(void)setBadge:(id)arg1 ;
-(void)asynchronouslyRequestIconImageForFormat:(int)arg1 completionHandler:(/*^block*/id)arg2 ;
-(id)generateIconImage:(int)arg1 ; //this grabs correct icon
-(id)badgeNumberOrString;
-(void)reloadIconImage;
@end



@interface SBApplicationController : NSObject
+(id)sharedInstance;
-(void)applicationService:(id)arg1 suspendApplicationWithBundleIdentifier:(id)arg2 ;
-(id)applicationWithBundleIdentifier:(id)arg1;
@end

@interface SBUIController : NSObject
-(void)activateApplication:(id)arg1;
@end
