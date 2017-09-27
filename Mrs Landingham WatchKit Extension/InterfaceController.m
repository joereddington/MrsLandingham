//
//  InterfaceController.m
//  Mrs Landingham WatchKit Extension
//
//  Created by Joseph Reddington on 15/08/2017.
//  Copyright © 2017 Joseph Reddington. All rights reserved.
//

#import "InterfaceController.h"
#import "WorkNode.h"
#import "DoNode.h"
#import "QuestionNode.h"
#import "LogController.h"
#import "WatchConnectivity/WatchConnectivity.h"

@interface InterfaceController ()

@end


@implementation InterfaceController

int x = 0;
bool firsttime=TRUE;
WorkNode * root;
WorkNode * currentNode;
LogController * logger;
WKAudioFilePlayer * audioFilePlayer;

- (void)startCountdown {
    _targetTime = [NSDate dateWithTimeInterval:300 sinceDate:[NSDate date]];
    [self.joetimer setDate:_targetTime];
    [_joetimer start];
}

- (void)awakeWithContext:(id)context {
    NSLog(@"enter 'wake with context''");
    [super awakeWithContext:context];
    self.mylabel.text =@"98";
    
    root=context;
    [self startCountdown];
    logger=[[LogController alloc] init];

    
    currentNode=root;
    
    //Audio file initialisation
    NSURL *assetURL = [[NSBundle mainBundle] URLForResource:@"ring" withExtension:@"wav"];
    WKAudioFileAsset *asset = [WKAudioFileAsset assetWithURL:assetURL];
    WKAudioFilePlayerItem *playerItem = [WKAudioFilePlayerItem playerItemWithAsset:asset];
    audioFilePlayer = [WKAudioFilePlayer playerWithPlayerItem:playerItem];


    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    NSLog(@"enter 'I will activate'");
    [self activateCurrentNode];
    NSLog(@"leave 'i will activate'");
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}



- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
- (void)activateCurrentNode {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"\n\n###### 20YY-MM-dd HH:mm\n"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    [logger writeLogWith: dateString];
    [logger writeLogWith: currentNode.message];
    if([currentNode isKindOfClass:[QuestionNode class]])
    {
        NSLog(@"It's a Question");
        QuestionNode * qn=(QuestionNode *)currentNode;
        if (qn.result==-1){//because it hasn't been asnswered{
            
            [self pushControllerWithName: @"QuestionController"  context: currentNode];
        }else if (qn.result==1){//no
            NSLog(@"Taken NO branch");

            currentNode=qn.elseChild;
            [self activateCurrentNode];
        }else {//yes
            currentNode=qn.child;
            [self activateCurrentNode];
        }
        qn.result=-1; //reseting because there are loops.
    }
    else{
        NSLog(@"It's a do");
        self.mylabel.text=currentNode.message;
        [self startCountdown];
    }
   
}

- (IBAction)Done {
    NSLog(@"hello");
    
    currentNode=currentNode.child;
    if (currentNode==NULL){
        self.mylabel.text=@"done";
    }else{
        [self activateCurrentNode];
        
    }
    [self tellThePhone];
}


- (IBAction)Problem {
    [self pushControllerWithName: @"choose"  context: @"here"];
    NSLog(@"hello");
}
- (IBAction)Expand {
    NSLog(@"start expanding");
    DoNode * temp=currentNode;
     currentNode=temp.expansion;
    [self activateCurrentNode];
    NSLog(@"done expanding");
}


- (void) tellThePhone {
    NSLog(@"Sending");
    NSLog([logger getLog]);
    NSString *counterString = currentNode.message; //[logger getLog ];
    NSLog(@"Okay then");
    NSLog(counterString);
    NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[counterString] forKeys:@[@"counterValue"]];
    
    [[WCSession defaultSession] sendMessage:applicationData
                               replyHandler:^(NSDictionary *reply) {
                                   NSLog(@"There was a reply");
                               }
                               errorHandler:^(NSError *error) {
                                   NSLog(@"There was an error");
                                   
                               }
     ];
    NSLog(@"Sent");
}

@end



