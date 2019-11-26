//
//  AboutMeViewController.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/9.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "AboutMeViewController.h"
#import <WebKit/WebKit.h>
@interface AboutMeViewController () <WKNavigationDelegate>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webview;
@property (nonatomic, strong) AutoScrollLabel *autoscrollTitle;

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.webview];
    [self.view addSubview:self.progressView];
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
    [self configNavBarButton];
}

- (void)configNavBarButton {
    self.autoscrollTitle = [[AutoScrollLabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH*0.6, 44)];
    self.navigationItem.titleView = self.autoscrollTitle;
}

- (void)setTitle:(NSString *)title {
    self.autoscrollTitle.text = title;
}

- (void)dealloc {
    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webview removeObserver:self forKeyPath:@"loading"];
    [self.webview removeObserver:self forKeyPath:@"title"];
}

#pragma mark - actions


#pragma mark - delegates
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
//    self.progressView.hidden = YES;
//    if(webView == self.webview) {
//        NSArray *views = [self.webview subviews];
//        for (UIView *view in views) {
//            view.backgroundColor = [UIColor clearColor];
//        }
//    }
    // 禁止放大缩小
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    //self.progressView.hidden = YES;
}

#pragma mark - 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.webview) {
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            //        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
            CGFloat newprogress = self.webview.estimatedProgress;
            if (newprogress >= 1) {
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            } else {
                self.progressView.hidden = NO;
                [self.progressView setProgress:newprogress animated:YES];
            }
            
            NSLog(@"%g", newprogress);
        } else if ([keyPath isEqualToString:@"loading"]) {
            NSLog(@"loading：%d", self.webview.isLoading);
        } else if ([keyPath isEqualToString:@"title"]) {
            self.title = self.webview.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - getters
- (WKWebView *)webview {
    if(!_webview) {
        _webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kNavigationBarHeight)];
        
        NSMutableString *javascript = [NSMutableString string];
        [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
        [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
        WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [_webview.configuration.userContentController addUserScript:noneSelectScript];
        
        // 添加监听
        [_webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webview addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
        [_webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        
        _webview.navigationDelegate = self;
    }
    return _webview;
}

- (UIProgressView *)progressView {
    if (!_progressView)
    {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 0)];
        _progressView.tintColor = [UIColor blueColor];
        _progressView.trackTintColor = UIColor.clearColor;
    }
    return _progressView;
}


@end
