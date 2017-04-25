//
//  BGPageControl.m
//  LittleCool
//
//  Created by 周博 on 2017/4/12.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BGPageControl.h"

@interface BGPageControl ()
{
    
    UIImage* activeImage;
    
    UIImage* inactiveImage;
    
}

@end

@implementation BGPageControl
-(id) initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    
    activeImage = [UIImage imageNamed:@"red-p.png"];
    
    inactiveImage = [UIImage imageNamed:@"write-p.png"];
    
    
    return self;
    
}


-(void) updateDots

{
    for (int i=0; i<[self.subviews count]; i++) {
        
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        CGSize size;
        
        size.height = 3;     //自定义圆点的大小
        
        size.width = 15;      //自定义圆点的大小
        [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.width)];
        if (i==self.currentPage){
            [dot setImage:activeImage];
        }else{
            [dot setImage:inactiveImage];
        }
    }
    
}

-(void) setCurrentPage:(NSInteger)page

{
    
    [super setCurrentPage:page];
    
    [self updateDots];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
