//
//  UIView+CountSize.m
//  Qian
//
//  Created by 周博 on 17/3/11.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "UIView+CountSize.h"

@implementation UIView (CountSize)

- (CGFloat)orginX{
    return self.frame.origin.x;
}

- (CGFloat)orginY{
    return self.frame.origin.y;
}

- (CGFloat)sizeWidth{
    return self.frame.size.width;
}

- (CGFloat)sizeHeight{
    return self.frame.size.height;
}

- (CGFloat)allHeight{
    return self.frame.size.height + self.frame.origin.y;
}

- (CGFloat)allWidth{
    return self.frame.size.width + self.frame.origin.x;
}

@end
