#import "Master.h"

@interface RAFFCardView : UIView <UIGestureRecognizerDelegate>
@property (nonatomic, assign) NSString * identifier;
@property (nonatomic, retain) SBApplication * application;
@property (nonatomic, retain) SBAppSwitcherSnapshotView * snapshot;
@property (nonatomic, assign) BOOL editing;
@property (nonatomic, retain) SBCloseBoxView * killButton;
-(id)initWithBundleIdentifier:(NSString *)arg1 view:(id)arg2;
// -(UIImageView *)snappShot;
-(UILabel *)appLabel;
-(UIImageView *)appIcon;
-(SBCloseBoxView *)killButton;
-(void)launchApp;
-(id)configuredSnapshot:(id)arg1;
@end
