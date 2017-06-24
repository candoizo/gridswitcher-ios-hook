#import "RAFFCardView.h"
#import "RAFFMultiView.h"
#import "objc/runtime.h"


@implementation RAFFCardView
-(id)initWithBundleIdentifier:(NSString *)arg1 view:(UIView *)arg2 {
  self = [super init];
    if (self) {
      self.bounds = CGRectMake(0,0,UIScreen.mainScreen.bounds.size.width*0.45, UIScreen.mainScreen.bounds.size.height*0.45);
      if (arg1) {
        _identifier = arg1;
        _application = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithBundleIdentifier:arg1]; // or use self.snapshot.application ?
        [self addSubview:[self configuredSnapshot:arg2]];

        [self addSubview:[self appLabel]];
        [self addSubview:[self appIcon]];

        [self bringSubviewToFront:self.snapshot];
        [self addSubview:[self killButton]];
      }
    }
  return self;
}

-(id)configuredSnapshot:(SBAppSwitcherSnapshotView *)arg1 {
  _snapshot = arg1;
  _snapshot.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)+8);
  _snapshot.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
  _snapshot.layer.masksToBounds = YES;
  _snapshot.layer.cornerRadius = self.bounds.size.width/17.5;

  UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchApp)];
  [_snapshot addGestureRecognizer:gestureRecognizer];

  // UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(killApp)];
  // [longTap setNumberOfTapsRequired:1]; // Set your own number here
  // [longTap setMinimumPressDuration:0.5];
  // [longTap setDelegate:self]; // Add the <UIGestureRecognizerDelegate> protocol
  // [gestureRecognizer requireGestureRecognizerToFail:longTap];   // Priority long
  // [_snapshot addGestureRecognizer:longTap];

  return _snapshot;
}

-(void)launchApp {
  // [UIApplication.sharedApplication launchApplicationWithIdentifier:self.identifier suspended:NO];
  if (self.editing) {self.editing = NO;}
  else if (((RAFFMultiView *)self.superview).launching) return;
  else {
  ((RAFFMultiView *)self.superview).launching = YES;
  [[objc_getClass("SBUIController") sharedInstance] activateApplication:self.application];

  [self.superview bringSubviewToFront:self];

  CGPoint old = self.center;
  CGAffineTransform t = self.snapshot.transform;

  [UIView animateWithDuration:0.3 animations:^{ //fill screen

    int page = ((UIScrollView *)self.superview).contentOffset.x / self.superview.frame.size.width;

       self.center =   CGPointMake(self.superview.center.x + (self.superview.bounds.size.width * page), self.superview.center.y-8); //CGPointMake(self.superview.center.x, self.superview.center.y-8);
       self.snapshot.transform =  CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    }
    completion:^(BOOL finished) {
      double delayInSeconds = 1.75;
	     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
       dispatch_after(popTime, dispatch_get_main_queue(), ^(void){ //revert
         self.center = old;
         self.snapshot.transform = t;
         self.superview.alpha = 0; //prepare for fade in
         ((RAFFMultiView *)self.superview).launching = NO;
       });

    }
  ];

  }
}


-(void)killApp{

  [UIView animateWithDuration:0.7 animations:^{
        self.alpha = 0;
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    }
    completion:^(BOOL finished) {

      [[objc_getClass("SBMainSwitcherViewController") sharedInstance] _quitAppRepresentedByDisplayItem:[objc_getClass("SBDisplayItem") displayItemWithType:@"App" displayIdentifier:self.identifier] forReason:1];

      // [((RAFFMultiView *)self.superview) rebuildViews];
      //fade in new page
      // [UIView animateWithDuration:0.3 animations:^{
      //   replace with nexxt page
      // } completion:nil];
    }
  ];


}

-(SBCloseBoxView *)killButton {
    SBCloseBoxView * k = [[objc_getClass("SBCloseBoxView") alloc] initWithFrame:CGRectMake(0,0,24,24)];
    k.center = CGPointMake(self.bounds.size.width-12, 26);
    k.hidden = YES;

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(killApp)];
    [k addGestureRecognizer:gestureRecognizer];
    return _killButton = k;
}

-(UILabel *)appLabel {
  UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.bounds.size.width,24)];
  name.textAlignment = 1;
  name.adjustsFontSizeToFitWidth = YES;
  name.textColor = UIColor.whiteColor;
  name.text = [self.identifier isEqualToString:@"com.apple.springboard"] ? @"Homescreen" : [self.application displayName];
  name.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
  return name;
}

-(UIImageView *)appIcon {
  UIImageView * ico = [[UIImageView alloc] initWithFrame:CGRectMake(15,0,[self appLabel].bounds.size.height,[self appLabel].bounds.size.height)];
  ico.center = CGPointMake(ico.center.x, [self appLabel].center.y);
  [[[objc_getClass("SBApplicationIcon") alloc] initWithApplication:self.application] asynchronouslyRequestIconImageForFormat:1 completionHandler:^(UIImage * result) {
     ico.image = result;
  }];
  return ico;
}

- (void)setEditing:(BOOL)arg1 {
  _editing = arg1;
  self.killButton.hidden = !arg1;
  if (arg1){

		CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity,((-2 * M_PI) / 180.0));
		CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, ((2.5 * M_PI) / 180.0));

		self.transform = leftWobble;  // starting point

		[UIView beginAnimations:@"iconShake" context:nil];
		[UIView setAnimationRepeatAutoreverses:YES]; // important
		[UIView setAnimationRepeatCount:9999];
		[UIView setAnimationDuration:0.21];
		[UIView setAnimationDelegate:self];
		//[UIView setAnimationDidStopSelector:@selector(didStopWobble)];
		self.transform = rightWobble; // end here & auto-reverse
		[UIView commitAnimations];

	} else {
		[self.layer removeAnimationForKey:@"iconShake"];
	}
}

@end
