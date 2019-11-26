//
//  AboutViewController.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/8.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutItemCell.h"
#import "AboutMeViewController.h"
#import "PersonalInformationView.h"
#import <UShareUI/UShareUI.h>

//static NSString *const EVENT_KEY = @"eventid";
//static NSString *const IMAGE_KEY = @"image";
//static NSString *const TITLE_KEY = @"title";
//static NSString *const DESC_KEY = @"desc";
//static NSString *const TYPE_KEY = @"type";


@interface AboutViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PersonalInformationView *personalHeaderView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *aboutItems;



@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
    [self setData];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    for (int i=0; i<self.aboutItems.count; i++) {
//        AboutItem *item = [self.aboutItems objectAtIndex:i];
//        if (item.eventid==0) {
//            item.desc = [NSString stringWithFormat:@"%.02fM", [ZLFileManager folderSizeAtPath:kDIRECTORY_CACHES]];
//            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//        }
//    }
    [self checkPermission];
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.personalHeaderView;
    
    
    UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
    
    UIButton *loginbtn = [ZLButtonFactory buttonWithTitle:@"退出登录" image:nil frame:CGRectZero target:self selector:@selector(login:)];
    
    loginbtn.size = CGSizeMake(80, 30);
    
    loginbtn.center = footerV.center;
    
    [footerV addSubview:loginbtn];
    
    
    self.tableView.tableFooterView = footerV;
    
    
}
- (void)setData {
    NSString *itemspath = [[NSBundle mainBundle] pathForResource:@"AboutItems" ofType:@"plist"];
    
    for (NSDictionary *dict in [NSArray arrayWithContentsOfFile:itemspath]) {
        AboutItem *item =  [AboutItem mj_objectWithKeyValues:dict];
        if (item.eventid==4) {
            item.title = [NSString stringWithFormat:@"关于%@", kAPP_DISPLAY_NAME];
            item.desc = [NSString stringWithFormat:@"版本%@", kAPP_VERSION];
        }
        
        if (item.eventid == 0) {
            item.desc = [NSString stringWithFormat:@"%.02fM", [ZLFileManager folderSizeAtPath:kDIRECTORY_CACHES]];
        }
        
        [self.aboutItems addObject:item];
    }

    
    [self.tableView reloadData];
    
    NSDictionary *personheaderDic = @{PIV_Image:[UIImage imageNamed:@"launchimg"],
                                      PIV_Nickname:@"ADreamClusive",
                                      PIV_Name:@"Jiaozl",
//                                      PIV_BgImage:[UIImage imageNamed:@"headbg"]
                                      };
    
    [self.personalHeaderView setContent:personheaderDic];
}

#pragma mark - actions

- (void)checkPermission {
    [PermissionCheck checkNotificationAuthorizationGrand:^{
        NSLog(@"已经拥有通知权限！");
    } withNoPermission:^{
        
        NSDate *lastdate = [kUSERDEFAULTS objectForKey:@"LAST_NOTICE_DATE"];
        if (lastdate && labs((long)[lastdate timeIntervalSinceNow]) < 3600*24) { // 设置一天之内不要重复提醒
            return;
        }
        [kUSERDEFAULTS setObject:[NSDate date] forKey:@"LAST_NOTICE_DATE"];
        
        NSLog(@"授权失败");
        JCAlertController *alert = [JCAlertController alertWithTitle:@"提示" message:@"为了获得最新资讯，请允许应用接收通知！"];
        [alert addButtonWithTitle:@"前往" type:JCButtonTypeNormal clicked:^{
            [self gotoPermissionSetting];
        }];
        [alert addButtonWithTitle:@"取消" type:JCButtonTypeCancel clicked:nil];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    [PermissionCheck openEventServiceWithBolck:^(BOOL shouldOn) {
        if (shouldOn) {
            JCAlertController *alert = [JCAlertController alertWithTitle:@"提示" message:@"检测到您当前不能连接到互联网，请检查您的网络设置"];
            [alert addButtonWithTitle:@"前往" type:JCButtonTypeNormal clicked:^{
                [self gotoPermissionSetting];
            }];
            [alert addButtonWithTitle:@"取消" type:JCButtonTypeCancel clicked:nil];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [ZLNetworkTools monitorNetworkChanges:^(AFNetworkReachabilityStatus status) {
                if (status == AFNetworkReachabilityStatusNotReachable) {
                    JCAlertController *alert = [JCAlertController alertWithTitle:@"提示" message:@"检测到您当前不能连接到互联网，请确保已经开启蜂窝移动数据或接入可用Wi——Fi"];
                    [alert addButtonWithTitle:@"好的" type:JCButtonTypeCancel clicked:nil];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }];
        }
    }];
}
- (void)gotoPermissionSetting{
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        //            [application openURL:URL options:@{} completionHandler:nil];
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    } else if([application respondsToSelector:@selector(openURL:)]) {
        [application openURL:URL];
    }
}

- (void)login:(id)sender {
    
}


- (void)aboutItemClicked:(NSInteger)eventType indexPath:(NSIndexPath *)indexPath {
    AboutItem *item = self.aboutItems[indexPath.row];
    switch (eventType) {
        case 0: // 当前页面弹窗操作
        {
            switch (item.subeventid) {
                case 0: {// 清理缓存
                    [self showActionSheet:indexPath];
                }
                break;
                case 1: {// 分享
                    [self shareSomeContent];
                }
                break;
                default:
                break;
            }
           
        }
            break;
        case 1: // 设置
        {
            Class clazz = NSClassFromString(@"CommonSettingViewController");
            ZLViewController *VC = [[clazz alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 2: // 根据配置，打开一个页面
        {
            
            Class clazz = NSClassFromString(item.desc);
            ZLViewController *VC = [[clazz alloc] init];
            VC.title = item.title;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 3: // 关于   跳转打开一个网页
        {
            AboutMeViewController *aboutusVC = [[AboutMeViewController alloc] init];
            aboutusVC.urlStr = item.desc;
            aboutusVC.title = item.title;
            [self.navigationController pushViewController:aboutusVC animated:YES];
        }
            break;
        default:
            break;
    }
}
    
- (void)shareSomeContent {
    [UMSocialUIManager setPreDefinePlatforms:@[
                                               @(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_WechatFavorite),
                                               @(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Qzone),
                                               @(UMSocialPlatformType_Sina)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        if(platformType == UMSocialPlatformType_Sina) {
            [self shareImageAndTextToPlatformType:platformType];
        } else {
            [self shareWebPageToPlatformType:platformType];
        }
    }];
}


// 登录授权信息
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    ZLWeakSelf;
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        

        /**
         // 用户取消
         Domain=UMSocialPlatformErrorDomain Code=2009 "(null)" UserInfo={message=操作取消}
         
         // 没有权限
         Domain=UMSocialPlatformErrorDomain Code=2003 "(null)" UserInfo={wetchatErrorCore=-1}
         
         // 授权失败，应用未通过审核
         Domain=UShare Code=21321 "(null)" UserInfo={message={
         error = "applications over the unaudited use restrictions!";
         "error_code" = 21321;
         request = "/2/users/show.json";
         }
         */
        
        if (error) {
            if ([error.domain isEqualToString:@"UShare"]) {
                NSDictionary *errormsg = error.userInfo[@"message"];
                if(errormsg[@"error"] && [((NSString *)errormsg[@"error"]) containsString:@"unaudited"]) {
                    [weakSelf.view makeToast:@"应用未通过授权登录官方审核" duration:1.0 position:CSToastPositionCenter];
                    
                } else {
                    [weakSelf.view makeToast:errormsg[@"error"] duration:1.0 position:CSToastPositionCenter];
                }
            }
        }
        
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.unionGender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
    }];
}

- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //设置文本
    messageObject.text = @"ADreamClusive简介：\n该博客包括：iOS、Mac OSx、Android、Linux、Fortran等相关使用及进阶知识。\n博主做过iOS、MacOSx、Android及Fortran科学计算实际工作。\n现主要从事iOS、MacOSx的开发工作。\n欢迎关注微信公众号：焦圈圈儿";
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    [shareObject setShareImage:@"https://avatar.csdn.net/6/5/1/1_u013943420.jpg?1542612151"];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  @"https://avatar.csdn.net/6/5/1/1_u013943420.jpg?1542612151";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:kAPP_DISPLAY_NAME descr:@"相关说明 \n该博客包括：iOS、Mac OSx、Android、Linux、Fortran等相关使用及进阶知识。\n博主做过iOS、MacOSx、Android及Fortran科学计算实际工作。\n现主要从事iOS、MacOSx的开发工作。\n实际中会穿插用到Html+Css+js前端知识、Python和Mac端以及Linux脚本知识，还有一些辅助工具的使用，都会在博客中体现，具体内容会尽可能详细的做好分类。\n查看博客过程中，如有任何问题，皆可随时沟通。" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"https://blog.csdn.net/u013943420";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}


- (void)showActionSheet:(NSIndexPath *)indexPath {
    
    NSArray *titleArray = @[@"清除缓存"];
    ZLWeakSelf;
    [ZLActionSheetManager showActionSheet:@"" message:@"选择是否清理缓存" actionTitles:titleArray inView:[weakSelf.tableView cellForRowAtIndexPath:indexPath] handler:^(UIAlertAction * _Nonnull action) {
        if(action.style == UIAlertActionStyleDefault) {
            if ([action.title isEqualToString:titleArray[0]]) {
                [ZLFileManager removeFilesAtPath:kDIRECTORY_CACHES];
                
                ((AboutItem *)self.aboutItems[indexPath.row]).desc = [NSString stringWithFormat:@"%.02fM", [ZLFileManager folderSizeAtPath:kDIRECTORY_CACHES]];
                
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
                [weakSelf.view makeToast:@"清理成功" duration:0.5 position:CSToastPositionCenter];
            }
        }
    }];

}

////创建一个alertview
//-(void)creatAlertController_alert {
//    //跟上面的流程差不多，记得要把preferredStyle换成UIAlertControllerStyleAlert
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"标题" message:@"注释信息,没有就写nil" preferredStyle:UIAlertControllerStyleAlert];
//
//    //可以给alertview中添加一个输入框
//    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder = @"alert中的文本";
//    }];
//
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"标题1" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"点击了按钮1，进入按钮1的事件");
//        //textFields是一个数组，获取所输入的字符串
//        NSLog(@"%@",alert.textFields.lastObject.text);
//    }];
//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"点击了取消");
//    }];
//
//    [alert addAction:action1];
//    [alert addAction:action2];
//
//    [self presentViewController:alert animated:YES completion:nil];
//}
#pragma mark - delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.aboutItems.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"AboutItemCell";
    AboutItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        //        cell = [[ProductPicsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell = [[NSBundle mainBundle] loadNibNamed:@"AboutItemCell" owner:self options:nil].lastObject;
    }
    
    AboutItem *item = self.aboutItems[indexPath.row];
    [cell setContent:item indexPath:indexPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self aboutItemClicked:[self.aboutItems[indexPath.row] eventid] indexPath:indexPath];
}

#pragma mark - getters

- (UITableView *)tableView {
    if (_tableView==nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kNavigationBarHeight-kTabBarHeight) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        
        //        _productPicsTableView.estimatedRowHeight = 0;
        //        _productPicsTableView.estimatedSectionHeaderHeight = 0;
        //        _productPicsTableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        //        _productListTableView.allowsSelection = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (PersonalInformationView *)personalHeaderView {
    if (!_personalHeaderView) {
        ZLWeakSelf;
        _personalHeaderView = [[PersonalInformationView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
//        _personalHeaderView.backgroundColor = UIColor.lightGrayColor;
        _personalHeaderView.didSelect = ^{
            NSLog(@"点击了头部视图");
            [weakSelf getUserInfoForPlatform:UMSocialPlatformType_Sina];
        };
    }
    return _personalHeaderView;
}

- (NSMutableArray *)aboutItems {
    if (!_aboutItems) {
        _aboutItems = [[NSMutableArray alloc] initWithCapacity:0];
        
    }
    return _aboutItems;
}



@end
