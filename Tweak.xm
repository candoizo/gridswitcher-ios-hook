#import "RAFFMultiView.h"

static RAFFMultiView * g;
//
// %ctor {
//
//   HBLogDebug(@"G IS %@", g);
// }

%hook SBMainSwitcherViewController
-(void)viewDidLoad{
  %orig;
  
  if (UIDevice.currentDevice.systemVersion.intValue < 11)
  {
  for (UIView * v in self.view.subviews) {
      v.hidden = YES;
    }
  g = [[RAFFMultiView alloc] init];
  g.alpha = 0; //prep for first view
  [self.view addSubview:g];
  }
}

-(void)performPresentationAnimationForTransitionRequest:(id)arg1 withCompletion:(id)arg3 {
  if (g) [g rebuildViews];
  %orig;
  if (g) [UIView animateWithDuration:0.575 animations:^{
            g.alpha = 1;
          }completion:nil];
}

-(void)performDismissAnimationForTransitionRequest:(id)arg1 toDisplayItem:(id)arg2 withCompletion:(id)arg3 {
  if (g && !g.launching) [UIView animateWithDuration:0.575 animations:^{
            g.alpha = 0;
          } completion:nil];
  %orig;
}

-(void)_appActivationStateDidChange:(id)arg1 {
  %orig;
   if (g)  [g.server updateSnapshotForBundle:((SBApplication *)[arg1 object]).bundleIdentifier];
}

-(void)_rebuildAppListCache {
  %orig;
  if (g) [g.server runningBundles];
}
%end
