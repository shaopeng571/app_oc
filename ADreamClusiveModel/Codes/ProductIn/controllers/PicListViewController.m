//
//  PicListViewController.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/7.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "PicListViewController.h"
#import "PicCollectionViewCell.h"

static NSString *PicCollectionViewCelliIdentify = @"PicCollectionViewCell";
static const CGFloat kLineSpacing = 1.f; //列间距 |
static const CGFloat kItemSpacing = 1.f; //item之间的间距 --行间距
static const NSInteger kRowNumber = 4; //列数



@interface PicListViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PYPhotoBrowseViewDelegate>

@property (nonatomic, strong) UICollectionView *picsCollectionView;

@property (nonatomic, strong) NSMutableArray *pics;

@property (nonatomic, strong) NSMutableArray *selectedPics;

@property (nonatomic, assign) BOOL shouldMultiSelect;

@property (nonatomic, strong) UIButton *selecteButton;

@property (nonatomic, assign) NSInteger selectedCount;


@end

@implementation PicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.shouldMultiSelect = NO;
    
    [self setupUI];
    
    [self setupData];
    
    
}

- (void) setupUI {
    self.title = @"图片列表";
    
    [self.view addSubview:self.picsCollectionView];
    
    [self configNavBarButton];
    
    [self setupToolBar];
    
    if (self.type==PicListViewTypeSelect) {
        self.navigationItem.hidesBackButton = YES;
        [self selectAction:self.selecteButton];
    }
}


- (void)configNavBarButton {
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setTitle:@"选择" forState:UIControlStateNormal];
    [selectBtn setTitle:@"取消" forState:UIControlStateSelected];
    [selectBtn sizeToFit];
    self.selecteButton = selectBtn;
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:selectBtn];
    self.navigationItem.rightBarButtonItems = @[selectItem];
}


- (void)setupData {
    [self.pics removeAllObjects];
    
    NSArray *picNames = [[ZLFileManager filenamesInPath:[ZLFileManager personalFilesPath] withExt:@"png" deep:YES] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    
    for (NSString *picpath in picNames) {
        ProPicInfoItem *item = [[ProPicInfoItem alloc] init];
        item.proimagepath = picpath.lastPathComponent;
        item.proinfo = item.proimagepath;
        [self.pics addObject:item];
        item = nil;
    }
    
    [self.picsCollectionView reloadData];
}

- (void)setupToolBar {
    UIButton *trashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [trashBtn addTarget:self action:@selector(trashAction:) forControlEvents:UIControlEventTouchUpInside];
    [trashBtn setImage:[UIImage imageNamed:@"trashbox"] forState:UIControlStateNormal];
    [trashBtn sizeToFit];
    UIBarButtonItem *trashItem = [[UIBarButtonItem alloc] initWithCustomView:trashBtn];
    
    UIBarButtonItem *finishButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", nil) style:UIBarButtonItemStylePlain target:self action:@selector(finishAction:)];
    finishButton.tintColor = kGetThemeColor;
    
    
    //item 的间隔，不会显示出来,会自动计算间隔
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    CGFloat toolbarHeight = 44;
    self.navigationController.toolbar.frame = CGRectMake(0, kSCREEN_HEIGHT-toolbarHeight, kSCREEN_WIDTH, toolbarHeight);
    self.toolbarItems = @[spaceItem, self.type==PicListViewTypeSelect?finishButton:trashItem];
}

#pragma mark - actions

- (void)browsePicFrom:(NSIndexPath *)indexpath {
    NSMutableArray *imageviews = [[NSMutableArray alloc] initWithCapacity:0];
    for (ProPicInfoItem *infoitem in self.pics) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageWithContentsOfFile:kWholePath(infoitem.proimagepath)];
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
    photoBroseView.showFromView = [self.picsCollectionView cellForItemAtIndexPath:indexpath];
    
    photoBroseView.delegate = self;
    
    // 3.显示(浏览)
    [photoBroseView show];
    
    
}

- (void)selectAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.navigationController.toolbarHidden = !sender.selected;
    
    
    if (!sender.selected && self.type==PicListViewTypeSelect) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    self.shouldMultiSelect = sender.selected;
    self.title = sender.selected?@"选择项目":@"图片列表";
    self.selectedCount = 0;
    self.navigationItem.hidesBackButton = sender.selected;
    
    self.picsCollectionView.height = kSCREEN_HEIGHT-kNavigationBarHeight-(sender.selected?self.navigationController.toolbar.height:0);
    
    if (!sender.selected) {
        for (int i=0; i<self.pics.count; i++) {
            ProPicInfoItem *item = self.pics[i];
            
            if (item.selected) {
                item.selected = NO;
                
                [_picsCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]];
            }
        }
    }
}

- (void)finishAction:(id)sender {
    
    for (int i=0; i<self.pics.count; i++) {
        ProPicInfoItem *item = self.pics[i];
        
        if (item.selected) {
            [self.selectedPics addObject:item];
        }
    }
    if (self.didFinishPickingImages) {
        self.didFinishPickingImages(self.selectedPics);
    }
    
    [self selectAction:self.selecteButton];
}

- (void)trashAction:(UIButton *)sender {
    for (int i=0; i<self.pics.count; i++) {
        ProPicInfoItem *item = self.pics[i];
        
        if (item.selected) {
            [self.selectedPics addObject:kWholePath(item.proimagepath)];
        }
    }
    [ZLFileManager removeFiles:self.selectedPics];
    
    [self setupData];
    
    [self selectAction:self.selecteButton];
}


- (void)updateSelectUI:(NSIndexPath *)indexPath selected:(BOOL)selected {
    
    [self.pics[indexPath.row] setSelected:selected];
    
    [(PicCollectionViewCell *)[self.picsCollectionView cellForItemAtIndexPath:indexPath] setPIC_selected:selected];
    
    selected?self.selectedCount++:self.selectedCount--;
    
    if (self.selectedCount==0) {
        self.title = @"选择项目";
    } else {
        self.title = [NSString stringWithFormat:@"已选择%ld张照片", (long)self.selectedCount];
    }
}

#pragma mark - delegates

// MARK: PYPhotoBrowseViewDelegate

- (void)photoBrowseView:(PYPhotoBrowseView *)photoBrowseView willHiddenWithImages:(NSArray *)images index:(NSInteger)index {
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [self.picsCollectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    UIView *view = [self.picsCollectionView cellForItemAtIndexPath:indexpath];
    
    photoBrowseView.hiddenToView = view;
}


//MARK: UICollectionDatasoure
//显示几个section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//每个section中显示多个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pics.count;
}
//配置单元格的方法
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PicCollectionViewCelliIdentify forIndexPath:indexPath];
    
    [cell setContentWithItem:self.pics[indexPath.row] indexpath:indexPath];
    
    return cell;
}

//MARK: UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (self.shouldMultiSelect) {
        [self updateSelectUI:indexPath selected:YES];
    } else {
        [self browsePicFrom:indexPath];
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.shouldMultiSelect) {
        [self updateSelectUI:indexPath selected:NO];
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
//每个单元格的大小size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat kCellWidth = (kSCREEN_WIDTH-kItemSpacing*(kRowNumber-1))/kRowNumber;//Cell高度
    return CGSizeMake(kCellWidth, kCellWidth);
}




#pragma mark - getters

- (UICollectionView *)picsCollectionView {
    if (!_picsCollectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = kLineSpacing;
        layout.minimumInteritemSpacing = kItemSpacing;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _picsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kNavigationBarHeight) collectionViewLayout:layout];
        _picsCollectionView.backgroundColor = [UIColor whiteColor];
        
        _picsCollectionView.delegate = self;
        _picsCollectionView.dataSource = self;
        
        
        // 多选
        _picsCollectionView.allowsMultipleSelection = YES;
        
        // 注册cell
        [_picsCollectionView registerNib:[UINib nibWithNibName:@"PicCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:PicCollectionViewCelliIdentify];
        
    }
    return _picsCollectionView;
}

- (NSMutableArray *)pics {
    if (!_pics) {
        _pics = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _pics;
}

- (NSMutableArray *)selectedPics {
    if (!_selectedPics) {
        _selectedPics = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _selectedPics;
}




@end
