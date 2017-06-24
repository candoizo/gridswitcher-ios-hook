@interface RAFFAppServer : NSObject
@property  dispatch_queue_t queue;
@property (nonatomic, retain) NSMutableArray * cachedBundles;
@property (nonatomic, retain) NSMutableDictionary * cachedSnapshots;
-(NSArray *)recentApps;
-(id)runningBundles;
-(void)updateSnapshotForBundle:(id)arg1;
@end
