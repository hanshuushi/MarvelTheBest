//
//  CustomNavigationController.m
//  Latte
//
//  Created by 范舟弛 on 12/6/16.
//  Copyright (c) 2016 FlyGo Inc. All rights reserved.
//

#import "CommonNavigationController.h"

@interface CommonNavigationController()
<
UIGestureRecognizerDelegate
>

@end

@implementation CommonNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = self;
    
    self.delegate = self;
}

#pragma mark - ovveride
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.interactivePopGestureRecognizer.enabled = NO;
    [super pushViewController:viewController animated:animated];
}

#pragma mark - Delegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    self.interactivePopGestureRecognizer.delegate = viewController;
    self.interactivePopGestureRecognizer.enabled = true;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count > 0 &&
        navigationController.viewControllers[0] != navigationController &&
        [navigationController.viewControllers containsObject:viewController])
    {
        viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return self.viewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return self.viewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class] && self.viewControllers.count > 1;
}


@end
