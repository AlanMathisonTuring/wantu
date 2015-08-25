//
//  WantUStatusPhotosView.m
//  wantu
//
//  Created by 吴新超 on 15/5/30.
//  Copyright (c) 2015年 wuxinchao. All rights reserved.
//

#import "WantUStatusPhotosView.h"
#import "WantUPhoto.h"
#import "WantUStatusPhotoView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define HWStatusPhotoWH 70
#define HWStatusPhotoMargin 10
#define HWStatusPhotoMaxCol(count) ((count==4)?2:3)
@implementation WantUStatusPhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    int photosCount = photos.count;
    
    
    // 创建足够数量的图片控件
    // 这里的self.subviews.count不要单独赋值给其他变量
    while (self.subviews.count < photosCount) {
        WantUStatusPhotoView *photoView = [[WantUStatusPhotoView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageOnClick:)];
        [photoView addGestureRecognizer:tap];
        photoView.userInteractionEnabled = YES;
        [self addSubview:photoView];
    }
    
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i<self.subviews.count; i++) {
        WantUStatusPhotoView *photoView = self.subviews[i];
        photoView.tag = i;
        if (i < photosCount) { // 显示
            photoView.photo = photos[i];
            photoView.hidden = NO;
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }
}

-(void)imageOnClick:(UITapGestureRecognizer*) tap{
    NSLog(@"----");
    UIImageView *tapView = tap.view;
    //WantUPhoto --> MJPhoto
    int i = 0;
    NSMutableArray *array = [NSMutableArray array];
    //将我们自定义photo的属性给MJPhoto
    for (WantUPhoto *wantuphoto in _photos) {
        MJPhoto *mjPhoto = [[MJPhoto alloc]init];
        NSString *urlStr = wantuphoto.thumbnail_pic;
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        mjPhoto.url = [NSURL URLWithString:urlStr];
        mjPhoto.index = i;
        mjPhoto.srcImageView = tapView;
        [array addObject:mjPhoto];
        i++;
    }
    //创建图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc]init];
    browser.photos = array;
    browser.currentPhotoIndex = tapView.tag;
    
    
    //显示
    [browser show];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    int photosCount = self.photos.count;
    int maxCol = HWStatusPhotoMaxCol(photosCount);
    for (int i = 0; i<photosCount; i++) {
        WantUStatusPhotoView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.x = col * (HWStatusPhotoWH + HWStatusPhotoMargin);
        
        int row = i / maxCol;
        photoView.y = row * (HWStatusPhotoWH + HWStatusPhotoMargin);
        photoView.width = HWStatusPhotoWH;
        photoView.height = HWStatusPhotoWH;
    }
}

+ (CGSize)sizeWithCount:(int)count
{
    // 最大列数（一行最多有多少列）
    int maxCols = HWStatusPhotoMaxCol(count);
    
    ///Users/apple/Desktop/课堂共享/05-iPhone项目/1018/代码/黑马微博2期35-相册/黑马微博2期/Classes/Home(首页)/View/HWStatusPhotosView.m 列数
    int cols = (count >= maxCols)? maxCols : count;
    CGFloat photosW = cols * HWStatusPhotoWH + (cols - 1) * HWStatusPhotoMargin;
    
    // 行数
    int rows = (count + maxCols - 1) / maxCols;
    CGFloat photosH = rows * HWStatusPhotoWH + (rows - 1) * HWStatusPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}

@end
