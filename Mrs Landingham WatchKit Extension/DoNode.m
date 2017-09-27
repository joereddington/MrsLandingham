//
//  DoNode.m
//  Mrs Landingham
//
//  Created by Joseph Reddington on 17/08/2017.
//  Copyright © 2017 Joseph Reddington. All rights reserved.
//

#import "DoNode.h"

@implementation DoNode



- (id) initWithStep: (NSString* ) payload {
    self.message=payload;
    self.child=NULL;
    return self;
}




    - (void)addStep:(NSString*) step{
        DoNode *node=[[DoNode alloc] initWithStep:step];
        [self addNode: node];
    }

- (void)addStep:(NSString*) step with: (WorkNode *) function{
    DoNode *node=[[DoNode alloc] initWithStep:step];
    node.expansion=function;
    [self addNode: node];
    //hmm, how do we tie this up?
    
}




@end

