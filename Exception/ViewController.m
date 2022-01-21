//
//  ViewController.m
//  Exception
//
//  Created by Max Wang on 1/20/22.
//

#import "ViewController.h"
#import "Observer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  for (int i = 0; i < 10; i++) {
    Observer *o = [[Observer alloc] initWithCount:@(i)];
    [o subscribe];
  }
  [Observer flush];
}


@end
