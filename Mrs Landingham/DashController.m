//
//  DashController.m
//  Mrs Landingham
//
//  Created by Joseph Reddington on 13/09/2017.
//  Copyright © 2017 Joseph Reddington. All rights reserved.
//

#import "DashController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "WatchConnectivity/WatchConnectivity.h"

@interface DashController ()
@property (weak, nonatomic) IBOutlet UILabel *counterString;
@end

@implementation DashController{
    
    WCSession *session;
    
}

//
//  DashController.m
//  Mrs Landingham
//
//  Created by Joseph Reddington on 13/09/2017.
//  Copyright © 2017 Joseph Reddington. All rights reserved.
//


//WCSession *session;
SystemSoundID sound1;
int startValue=300;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.counter = startValue;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                   selector:@selector(advanceTimer:)
                                   userInfo:nil
                                    repeats:YES];
    //Comunication is needed .
    if ([WCSession isSupported]) {
        session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)playsound:(id)sender {
   //timer
    [self playSoundCalled:@"ring"];
    self.counter=startValue;
    
}


- (void) playSoundCalled: (NSString *) nameOfFile{
    AudioServicesPlaySystemSound(sound1);
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:nameOfFile ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundPath], &soundID);
    AudioServicesPlaySystemSound(soundID);
}


- (void)advanceTimer:(NSTimer *)timer
{
    NSLog(@"advance timer");
    NSLog(@"%@", [NSString stringWithFormat:@"counter %d", self.counter]);
    self.counter=self.counter-1;
    self.counterString.text=[NSString stringWithFormat:@"Seconds remaining: %d", self.counter];
    if (self.counter == 10) { [self playSoundCalled:@"countdown"]; }
    if (self.counter <= 0) { [timer invalidate]; }
}

- (void)session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary *)message replyHandler:(nonnull void (^)(NSDictionary * __nonnull))replyHandler {
    NSLog(@"in the communcation");
    [self playSoundCalled:@"ring"];
    self.counter=startValue;

}





@end
