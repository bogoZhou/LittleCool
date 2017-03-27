//
//  AssetModel.h
//  LittleCool
//
//  Created by 周博 on 17/3/19.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseModel.h"


/**
 ALAsset *asset = _dataArray[indexPath.row];
 
 ALAssetRepresentation* representation = [asset defaultRepresentation];
 
 cell.imageViewHeader.image = [UIImage imageWithCGImage:[representation fullResolutionImage]];
 
 cell.labelTitle.text = [representation filename];
 
 NSDate* pictureDate = [asset valueForProperty:ALAssetPropertyDate];
 
 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
 [formatter setDateStyle:NSDateFormatterMediumStyle];
 [formatter setTimeStyle:NSDateFormatterShortStyle];
 [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
 NSString *nowtimeStr = [formatter stringFromDate:pictureDate];
 */
@interface AssetModel : BaseModel

@property (nonatomic,strong) NSString *titleName;

@property (nonatomic,strong) UIImage *headImage;

@property (nonatomic,strong) NSString *DateString;

@property (nonatomic,strong) NSURL *url;

@property (nonatomic,strong) NSString *type;

@end
