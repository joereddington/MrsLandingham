//
//  workNode.m
//  Mrs Landingham
//
//  Created by Joseph Reddington on 17/08/2017.
//  Copyright © 2017 Joseph Reddington. All rights reserved.
//

#import "WorkNode.h"

@implementation WorkNode

//This is the base class.  Will only be used as for polymorphism.



- (void) activate{
}

- (void)addNode:(WorkNode*) target  {
    if (self.child==NULL){
        self.child=target;
    }else{
        [self.child addNode:target];
    }
    
}

- (NSString *)description {
    return [NSString stringWithFormat: @"Do:%@\n%@", self.message, self.child];
}


@end
