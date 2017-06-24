#import "Master.h"

#import "RAFFMultiView.h"
#import "objc/runtime.h"

//@TODO make this a configurable page, ability to specify 1x1, 2x2, 3x3
@implementation RAFFMultiView

/*
    Paging: number of pages
    Grid Setup ? 1x1, 2x2, 3x3, icons
    Card Style: icons , page previews,
    Background style: blured styling / bare
*/


-(id)init {
    if (self == [super init]) {
      self.frame = UIScreen.mainScreen.bounds;

      //config prefs
      _prefs = [[NSUserDefaults alloc] initWithSuiteName:@"ca.ndoizo.gridswitch"];
      [self.prefs registerDefaults:@{
        // Preferences
        @"background" : @5,
        @"grid" : @1,

      }];

      _server = [[RAFFAppServer alloc] init];

      //config scrollview
      self.pagingEnabled = YES;
      self.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height); // * pages, also vertical vs horizontal
      [self addSubview:[self backgroundStyle:[self.prefs integerForKey:@"background"]]];
      [self performSelector:@selector(rebuildViews) withObject:nil afterDelay:2.0f];
    }
  return self;
}

-(id)backgroundStyle:(int)arg1 {
  return [[objc_getClass("_UIBackdropView") alloc] initWithFrame:self.bounds style:arg1];
}

// -(int)grid {
//   return [[self.prefs valueForKey:@"grid"] intValue];
// }
//
// -(void)buildGrid:(int)arg1 {
//   switch (arg1) {
//     case 1: //1x1
//
//     case 2: //2x2
//
//     case 3; //3x3
//
//     break;
//
//     default
//
//     break;
//   }
// }


-(void)rebuildViews {


  for (UIView *v in self.subviews) {
    if (![v isMemberOfClass:objc_getClass("_UIBackdropView")])[v removeFromSuperview];
  }

  for (int i = 0; i < 12; i++) { //self.server.cachedBundles.count
    UIView * display = self.server.cachedSnapshots[self.server.cachedBundles[i]];
    RAFFCardView * c = [[RAFFCardView alloc] initWithBundleIdentifier:self.server.cachedBundles[i] view:display];
    c.center = CGPointMake(self.bounds.size.width * (((i+1) & 1) ? 0.25 : 0.75 ), self.bounds.size.height * (((i+1) & 2) ?  0.28 : 0.75)); //:D yay me

    // pages / grid * grid
    c.center = CGPointMake(c.center.x + (self.frame.size.width * (i/4)) , c.center.y);

    [self addSubview:c];
  }
}

@end
