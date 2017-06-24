#import "RAFFAppServer.h"
#import "RAFFCardView.h"

@interface RAFFMultiView : UIScrollView
@property (nonatomic) NSUserDefaults * prefs;
@property (nonatomic, retain) RAFFAppServer * server;
@property (nonatomic, assign) BOOL launching;
-(id)backgroundStyle:(int)arg1;
-(void)rebuildViews;
@end
