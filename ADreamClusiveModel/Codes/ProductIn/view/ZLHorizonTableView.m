//
//  ZLHorizonTableView.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/1.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ZLHorizonTableView.h"
#import "ProductPicsTableViewCell.h"
#import "PicListViewController.h"

@interface ZLHorizonTableView() <UITableViewDelegate, UITableViewDataSource, TZImagePickerControllerDelegate, PYPhotoBrowseViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) HorizonTableViewType type;

@end

@implementation ZLHorizonTableView

- (instancetype)initWithFrame:(CGRect)frame type:(HorizonTableViewType)type {
    self = [self initWithFrame:frame];
    self.type = type;
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
        self.type = HorizonTableViewTypeShow;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = UIColor.lightGrayColor.CGColor;
        self.layer.cornerRadius = 5.0;
    }
    return self;
}


- (void)setType:(HorizonTableViewType)type {
    _type = type;
    if (_type == HorizonTableViewTypeEdit) {
        UIImageView *addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.height, self.height)];
        addImageView.userInteractionEnabled = YES; // 允许响应用户交互
        addImageView.contentMode = UIViewContentModeCenter;
        addImageView.image = [UIImage imageNamed:@"compose_pic_add"];
       
        UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapClick:)];
        singleTapGR.numberOfTapsRequired = 1;
        [addImageView addGestureRecognizer:singleTapGR];
        
        UITapGestureRecognizer *doubleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapClick:)];
        doubleTapGR.numberOfTapsRequired = 2;
        [addImageView addGestureRecognizer:doubleTapGR];
        
        //只有当doubleTapGesture识别失败的时候(即识别出这不是双击操作)，singleTapGesture才能开始识别
        [singleTapGR requireGestureRecognizerToFail:doubleTapGR];
        
        _tableView.tableFooterView = addImageView;
    }
}

- (void)setDatasource:(NSArray *)datasource {
    _datasource = [[NSMutableArray alloc] initWithCapacity:0];
    [_datasource addObjectsFromArray:datasource];
    [_tableView reloadData];
}

#pragma mark - actions

- (void)singleTapClick:(UITapGestureRecognizer *)tapGr {
    TZImagePickerController *imagepickVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    [self.viewContainingController presentViewController:imagepickVC animated:YES completion:nil];
}

- (void)doubleTapClick:(UITapGestureRecognizer *)tapGr {
    ZLWeakSelf;
    PicListViewController *picVC = [[PicListViewController alloc] init];
    picVC.type = PicListViewTypeSelect;
    picVC.didFinishPickingImages = ^(NSArray<ProPicInfoItem *> * _Nonnull items) {
        [weakSelf.datasource addObjectsFromArray:items];
        [weakSelf.tableView reloadData];
    };
    [self.viewContainingController.navigationController pushViewController:picVC animated:YES];
}

- (void)browsePicFrom:(NSIndexPath *)indexpath {
    NSMutableArray *imageviews = [[NSMutableArray alloc] initWithCapacity:0];
    for (ProPicInfoItem *infoitem in self.datasource) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.viewContainingController.view.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;

        imageView.image = [UIImage imageWithContentsOfFile:kWholePath(infoitem.proimagepath)]?:kDefaultImage;
        [imageviews addObject:imageView];
        imageView = nil;
    }
    
    
    
    // 1. 创建photoBroseView对象
    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
    
    // 2.1 设置图片源(UIImageView)数组
    photoBroseView.sourceImgageViews = imageviews;
    // 2.2 设置初始化图片下标（即当前点击第几张图片）
    photoBroseView.currentIndex = indexpath.row;
    
    // 从哪个位置开始慢慢放大显示
    photoBroseView.showFromView = [self.tableView cellForRowAtIndexPath:indexpath];

    photoBroseView.delegate = self;

    // 3.显示(浏览)
    [photoBroseView show];


}


#pragma mark - delegates

// MARK: PYPhotoBrowseViewDelegate

- (void)photoBrowseView:(PYPhotoBrowseView *)photoBrowseView willHiddenWithImages:(NSArray *)images index:(NSInteger)index {
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    
    UIView *view = [self.tableView cellForRowAtIndexPath:indexpath];
    
    photoBrowseView.hiddenToView = view;
}

#pragma mark imgpicdelegates

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    //    self.imagesArr = photos;
    
    for (int i=0; i<photos.count; i++) {
        //        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        UIImage *image = photos[i];
        PHAsset *asset = assets[i];
        NSTimeInterval timeStamp = [asset.creationDate timeIntervalSince1970];
        BOOL result = [ZLFileManager saveImage:image WithName:[NSString stringWithFormat:@"%f.png", timeStamp]];
        
        ProPicInfoItem *picinfoItem = [[ProPicInfoItem alloc] init];
        picinfoItem.proimagepath = [NSString stringWithFormat:@"%f.png", timeStamp];
        picinfoItem.proinfo = [NSString stringWithFormat:@"%f", timeStamp];
        [self.datasource addObject:picinfoItem];
        picinfoItem = nil;
    }
    
    [self.tableView reloadData];
}

#pragma mark TableViewDelegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"ProductPicsTableViewCell";
    ProductPicsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        //        cell = [[tableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell = [[NSBundle mainBundle] loadNibNamed:@"ProductPicsTableViewCell" owner:self options:nil].lastObject;
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        if (self.type==HorizonTableViewTypeShow) {
            cell.showDeleteBtn = NO;
        } else {
            
            cell.showDeleteBtn = YES;
        }
    }
    
    if (self.type==HorizonTableViewTypeEdit) {
        ZLWeakSelf;
        cell.deletePic = ^(NSIndexPath * _Nonnull indexpathsss) {
            [weakSelf.datasource removeObjectAtIndex:indexPath.row];
            
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexpathsss] withRowAnimation:UITableViewRowAnimationAutomatic];
        
            [weakSelf.tableView reloadData];
        };
    }
    
    [cell setContentWithItem:self.datasource[indexPath.row] indexpath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self browsePicFrom:indexPath];
}




#pragma mark - getters

- (UITableView *)tableView {
    if (_tableView==nil) {
        CGFloat x = 0, y = 0, w = self.width, h = self.height;
        CGFloat w1 = h, h1 = w, x1 = x - (h-w)*0.5, y1 = y + (h-w)*0.5;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(x1, y1, w1, h1) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //tableview逆时针旋转90度。
        CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI_2);
        _tableView.transform = transform;
        _tableView.layoutMargins = UIEdgeInsetsZero;
        
        //        _tableView.estimatedRowHeight = 0;
        //        _tableView.estimatedSectionHeaderHeight = 0;
        //        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.allowsSelection = NO;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
    
    //    (a = 0.00000000000000006123233995736766, b = -1, c = 1, d = 0.00000000000000006123233995736766, tx = 0, ty = 0)
}



@end
