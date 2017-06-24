#import "Master.h"
#import "RAFFAppServer.h"
#import "objc/runtime.h"

@implementation RAFFAppServer
-(id)init {
  if (self == [super init]) {
    _queue = dispatch_queue_create("snapshotQueue", DISPATCH_QUEUE_CONCURRENT);
  }
  return self;
}

//um also could us NSUserDefaults.standardUserDefauult valueForKey:@"SBRecentDisplayItems"
-(NSArray *)recentApps { //refcent running apps
  return [[objc_getClass("SBAppSwitcherModel") sharedInstance] valueForKey:@"_recentDisplayItems"];
}

-(NSMutableArray *)runningBundles {
  NSMutableArray * a = [[NSMutableArray alloc] initWithCapacity:[self recentApps].count];

  // [a addObject:@"com.apple.springboard"]; //add springboard

  for (SBDisplayItem * o in [self recentApps]) {
    [a addObject:o.displayIdentifier];
  }
      HBLogDebug(@"running bundles are %@", a);
  return self.cachedBundles = a;
}

-(NSMutableDictionary *)buildSnapshots {
  NSMutableDictionary * d = [[NSMutableDictionary alloc] initWithCapacity:self.cachedBundles.count];

  //@TODO find out why this doesnt load the homescreen image
  // SBAppSwitcherSnapshotView *s = [objc_getClass("SBAppSwitcherSnapshotView") appSwitcherSnapshotViewForDisplayItem:[self springboardSnapshot] orientation:0 preferringDownscaledSnapshot:YES loadAsync:YES withQueue:self.queue];
  // [s _loadSnapshotAsyncPreferringDownscaled:YES];
  // [d setValue:s forKey:@"com.apple.springboard"];

      for (SBDisplayItem * o in [self recentApps]) {
          SBAppSwitcherSnapshotView *snap = [objc_getClass("SBAppSwitcherSnapshotView") appSwitcherSnapshotViewForDisplayItem:o orientation:0 preferringDownscaledSnapshot:YES loadAsync:YES withQueue:self.queue];
          [snap _loadSnapshotAsyncPreferringDownscaled:YES];
          [d setValue:snap forKey:o.displayIdentifier];
      }

      HBLogDebug(@"snapshot d is %@", d);
      return self.cachedSnapshots = d;
}

-(id)cachedBundles {
  return _cachedBundles ?: [self runningBundles];
}

-(id)cachedSnapshots {
  return _cachedSnapshots ?: [self buildSnapshots];
}

-(id)springboardSnapshot {
  return [objc_getClass("SBDisplayItem") homeScreenDisplayItem];
}

-(void)updateSnapshotForBundle:(NSString *)arg1 {
  SBAppSwitcherSnapshotView *snapshotView = self.cachedSnapshots[arg1];
  [snapshotView _loadSnapshotAsyncPreferringDownscaled:YES];
}
@end
