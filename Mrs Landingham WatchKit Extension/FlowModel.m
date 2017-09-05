//
//  FlowModel.m
//  Mrs Landingham
//
//  Created by Joseph Reddington on 27/08/2017.
//  Copyright © 2017 Joseph Reddington. All rights reserved.
//

#import "FlowModel.h"
#import "WorkNode.h"
#import "DoNode.h"
#import "QuestionNode.h"
#import "PickerController.h"

@implementation FlowModel
NSMutableArray * pickerItems;
NSMutableArray * workNodeItems;


- (void)make_initial_menu {
    pickerItems = [[NSMutableArray alloc] init];
    workNodeItems = [[NSMutableArray alloc] init];
    [self makeItemWith:@"Morning" startNode: [self morning] ];
    [self makeItemWith:@"Night" startNode: [self night]] ;
    [self makeItemWith:@"Coff Shop" startNode: [self enterCoffeeShop] ];
    [self makeItemWith:@"Question Test" startNode: [self questionTest]];
    [self makeItemWith:@"Plan Day"  startNode: [self plan_day]];
}


- (void)make_problem_menu {
    pickerItems = [[NSMutableArray alloc] init];
    workNodeItems = [[NSMutableArray alloc] init];
    [self makeItemWith:@"I feel resistence to doing it" startNode: [[DoNode alloc] initWithStep:@"Write down the smallest physical step on the notes file"] ];
       [self makeItemWith:@"The algorithm is incomplete" startNode: [[DoNode alloc] initWithStep:@"Rewrite Mrs Landingham to cover this instance."] ];
    [self makeItemWith:@"The algorithm is incomplete" startNode: [self night]] ;
    [self makeItemWith:@"There are special circumstances outside the algorithm" startNode: [self enterCoffeeShop] ];
    [self makeItemWith:@"This task would be better done at the same time as another apointment" startNode: [self questionTest]];
    [self makeItemWith:@"Interuption"  startNode: [self plan_day]];
    [self makeItemWith:@"This is a cron and I've run out of resource"  startNode: [self plan_day]];
}



- (void) makeItemWith: (NSString *) input startNode: (WorkNode *) startNode {
    WKPickerItem *pickerItem4 = [WKPickerItem alloc];
    [pickerItem4 setTitle:input];
    [pickerItem4 setAccessoryImage:[WKImage imageWithImageName:@"Smile"]];
    [pickerItems addObject: pickerItem4 ];
    [workNodeItems addObject: startNode];
}


- (WorkNode *) getWorkNodeAt: (int) input {
    return [workNodeItems objectAtIndex: input];
}


- (WorkNode *)setup_doghouse {
    DoNode *local=[[DoNode alloc] initWithStep:@"Get full water bottle"];
    [local addStep: @"Put Phone on charge"];
    [local addStep: @"Tell phone Instramental music" ];
    [local addStep: @"Put everything on one side of the desk and process it" ];
    return local;
}





- (WorkNode *)project_review {
    DoNode *local=[[DoNode alloc] initWithStep:@"Check and respond to project notifications."];
    [local addStep: @"Open EQT Projects Board"];
    [local addNode:[self project_normal_form]];
    [local addStep: @"Open Personal Projects Board"];
    [local addNode:[self project_normal_form]];
    return local;
    
}

- (WorkNode *)project_normal_form {
    DoNode *local=[[DoNode alloc] initWithStep:@"Make sure all issues have been imported to the board."];
    [local addStep: @"Removed closed issues"];
    [local addStep: @"Check that every card is assigned"];
    return local;
    
}

    /*
     def review_projects():
     def project_normal_form():
     do("Open the project board")
     do("Make sure that all issues have been imported to the board.")
     do("Close issues")
     do("Remove closed issues.")
     do("Check that every card is assigned")
     while (True):
     if(ask("Are there projects to review?")):
     do("Check project is assigned")
     do("Check project is mapped")
     do("If someone else is assigned the project, then write a note to them")
     do("Put two action's into the project, and into melta")
     else:
     return
     
     
     do("Check and respond to project notifications.")
     do("Review EQT projects board",project_normal_form)
     do("Review Jarvis projects board",project_normal_form)
*/


- (NSMutableArray*) getPickerItems{
    return pickerItems;
    
    
}

- (WorkNode *) melta_normal_form {
    DoNode *local=[[DoNode alloc] initWithStep:@"Open Next Actions"];
    [local addStep: @"Add tasks from phone screenshots."];
    [local addStep: @"Check Voicemail and add any messages to Tasks."];
    [local addStep: @"Check notebook/brainstorms for tasks"];
    [local addStep: @"Go thought Osprey bag - everything that isn't intended to be there is a task."];
    [local addStep: @"Sort the next actions file alphabetically, this will put the least defined tasks at the top."];
    [local addStep: @"Fill in the priority, and time (mark off done tasks)"];
    [local addStep: @"Note now much time for the full list"];
    [local addStep: @"Do any tasks that take less than five minutes (morning power hour!)"];
    [local addStep: @"Check if some tasks have already been done"];
    [local addStep: @"Rewrite tasks thinking about how public they are"];
    [local addStep: @"Messsage Kat a list of the ones relevent to her"];
    [local addStep: @"Go thought all tasks and adjust the deadline for an urgent ones"];    return local;
}

- (WorkNode *)start_laptop {
    DoNode *local=[[DoNode alloc] initWithStep:@"Open Jurgen and livenotes"];
    [local addStep: @"Open Prioirty and Time Chart (for flow)"];
    [local addStep: @"Close other programs (not terminal)"];
    [local addStep: @"Put Bank Balance on livenotes"];
    [local addStep: @"Put the thing you are most worried abotu in next actions"];
    [local addNode:[self melta_normal_form]];
    return local;
}

- (WorkNode *)alarm_has_gone_off {
    DoNode *local=[[DoNode alloc] initWithStep:@"Stand up"];
    [local addStep: @"Write the 'context stack' down on a log if you have one"];
    [local addStep: @"Do the thing"];
    return local;
}

- (WorkNode *)plan_day {
     DoNode *local=[[DoNode alloc] initWithStep:@"Open Calendar"];
    
    DoNode *yesNode=[[DoNode alloc] initWithStep:@"Change to Skype"];
    [yesNode addStep: @"Change to Skype"];
    [yesNode addStep: @"Think of a way to make it awesome"];
    [yesNode addStep: @"Add any tasks about appointment"];//which wil have prioirt 0 and happen first
    [yesNode addStep: @"Set Alarm for travel"];
    
    DoNode *noNode=[[DoNode alloc] initWithStep:@"Set Alarm for exercise"];
    [noNode addStep: @"Set Alarm for email"];
    [noNode addStep: @"Set Alarm for food"];
    
    
    QuestionNode *start=[[QuestionNode alloc] initWithQuestion: @"Are there any unprocessed apointments?" yesChild: yesNode noChild:noNode];
    [yesNode addNode: start];
   
    [local addNode:start];
    return local;
}



- (WorkNode *)morning {
    DoNode *local=[[DoNode alloc] initWithStep:@"Kitchen: Start Kettle boiling"];
    [local addStep: @"Bathroom" ];
    [local addStep: @"Bath: Drink 1L Water" ];
    [local addStep: @"Bath: Shower"];
    [local addStep: @"Bath: Dress"];
    [local addStep: @"Bath: Exfoliate"];
    [local addStep: @"Bath: Consider face strip"];
    [local addStep: @"Bath: Shave"];
    [local addStep: @"Bath: Shave head"];
    [local addStep: @"Bath: Shave"];
    [local addStep: @"Bath: Teeth"];
    [local addStep: @"Bath: Floss"];
    
    [local addStep: @"Kitc: clothes in wash"];
    [local addStep: @"Kitc:Vitimin Tablet"];
    [local addStep: @"Kitc:Make Tea (get washing)"];
    [local addStep: @"Go To Doghouse"];
    [local addNode: [self setup_doghouse]];
    [local addNode: [self start_laptop]];
    [local addNode: [self plan_day]];
    return local;
}






- (WorkNode *)questionTest {
    DoNode *local=[[DoNode alloc] initWithStep:@"This is the beginging"];
    [local addStep: @"1"];
    [local addStep: @"2"];
    [local addStep: @"3"];
    DoNode *yesNode=[[DoNode alloc] initWithStep:@"Then Celebrate"];
    DoNode *noNode=[[DoNode alloc] initWithStep:@"Then fix it"];
    QuestionNode *testQ=[[QuestionNode alloc] initWithQuestion: @"Do you want to go back to the begining?" yesChild: local noChild:noNode];
    [local addNode:testQ];
    [noNode addNode: [self morning]];
    NSLog(@"We have populated the algorithm tree");
    return local;
}



- (WorkNode *) enterCoffeeShop{
    DoNode *local=[[DoNode alloc] initWithStep:@"Smile"];
    [local addStep: @"Order a green tea and a glass of tap water"];//No sugar, only peace
    [local addStep: @"Find seat with plug"];
    [local addStep: @"Spread things around table"];
    [local addStep: @"Take off shoes and a layer"];
    [local addStep: @"Everything on charge"];
    [local addStep: @"Set timer for leaving"];
    [local addStep: @"Get a local next actions"];
    return local;
    
}

- (WorkNode *) night{
    DoNode *local=[[DoNode alloc] initWithStep:@"Laptop on charge"];
    [local addStep: @"Glasses in Ospray"];
    [local addStep: @"Headphones on charge"];
    [local addStep: @"Night Glasses On"];
    [local addStep: @"Lock Door"];
    [local addStep: @"Put glass in bathroom (and drink it)"];
    [local addStep: @"Teeth"];
    [local addStep: @"Floss"];
    [local addStep: @"Leave good clothes in bathroom"];
    [local addStep: @"otherclothes in washing machine"];
    [local addStep: @"Get tomorrow's clothes from bedroom"];
    [local addStep: @"Keys in bag"];
    [local addStep: @"Wallet has two bank cards"];
    [local addStep: @"Phone on charge"];
    [local addStep: @"Food in bag"];
    [local addStep: @"Bike lights"];
    [local addStep: @"Pens and notebook in bag"];
    [local addStep: @"Spare battery"];
    [local addStep: @"Other battery on charge"];
    [local addStep: @"MacBook charger"];
    [local addStep: @"folding plug"];
    [local addStep: @"Seal bag"];
    [local addStep: @"Setup tea and water bottles"];
    [local addStep: @"Sleep mask on head"];
    [local addStep: @"What is the next thing in the memory palace?"];
    [local addStep: @"Lights out"];
    [local addStep: @"watch on charge"];
    return local;
    
}



@end
