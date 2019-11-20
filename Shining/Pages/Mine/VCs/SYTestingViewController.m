//
//  SYTestingViewController.m
//  Shining
//
//  Created by letv_lzb on 2019/6/3.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYTestingViewController.h"
#import "SYTestWebViewController.h"

@interface SYTestingViewController ()
@property (nonatomic, strong) UILabel *testLabel;

@property (nonatomic, strong) UISwitch *testSwitch;
@property (nonatomic, strong) UISwitch *testHKSwitch;
@property (nonatomic, strong) UISwitch *testHttpsSwitch;
@property (nonatomic, strong) UIButton *testCleanButton;
@property (nonatomic, strong) UIButton *h5TestButton;
@property (nonatomic, strong) UISwitch *testAdServerSwitch;
@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UILabel *useHardDecodeLabel;
@property (nonatomic, strong) UISwitch *useHardDecodeSwitch;
/**
 *  是否是测试环境
 */
@property (assign) BOOL isTestApi;
@property (assign) BOOL isHKTestApi;
@property (assign) BOOL isTestHttps;
@property (assign) BOOL isUseAdTestingServer;
@property (nonatomic, strong) NSDictionary *cityInfo;
@end

@implementation SYTestingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor sy_colorWithHexString:@"#FFFFF7"];
    [self setMyTitle:@"调试设置"];
    // Do any additional setup after loading the view.
    self.isTestApi = [SYSettingManager syIsTestApi];
    self.isTestHttps = NO;//[[NSUserDefaults standardUserDefaults] boolForKey:kTestHttpsKey];
    self.isUseAdTestingServer = NO;//[[NSUserDefaults standardUserDefaults] boolForKey:kUseAdTestingServer];
    self.testLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 64 + (iPhoneX ? 24 : 0) + 30 , 100, 30)];
    self.testLabel.backgroundColor = [UIColor clearColor];
    self.testLabel.text = @"开启测试环境";
    self.testLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.testLabel];

    self.testSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.testLabel.frame.origin.x + self.testLabel.frame.size.width,
                                                                 self.testLabel.frame.origin.y,
                                                                 50, 30)];
    [self.testSwitch setOn:self.isTestApi animated:YES];
    [self.testSwitch addTarget:self action:@selector(clickTestSlider:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.testSwitch];

    /*
    CGRect frame = self.testLabel.frame;
    frame.origin.y += frame.size.height + 10;
    frame.size.width += 30;
    UILabel *testHKLabel = [[UILabel alloc] initWithFrame:frame];
    testHKLabel.text = @"开启香港测试环境";
    testHKLabel.backgroundColor  = [UIColor clearColor];
    testHKLabel.font = [UIFont systemFontOfSize:15];
    [testHKLabel setFrame:frame];
    [self.view addSubview:testHKLabel];


    self.isHKTestApi = [[NSUserDefaults standardUserDefaults] boolForKey:kHKTestAPIKey];
    self.testHKSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(testHKLabel.frame.origin.x + testHKLabel.frame.size.width,
                                                                   testHKLabel.frame.origin.y,
                                                                   50, 30)];
    [self.testHKSwitch setOn:self.isHKTestApi animated:YES];
    [self.testHKSwitch addTarget:self action:@selector(clickHKTestSlider:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.testHKSwitch];
     */

    CGRect frame2 = self.testLabel.frame;
    frame2.origin.y += frame2.size.height + 10;
    frame2.size.width += 30;
    UILabel *testHttpsLabel = [[UILabel alloc] initWithFrame:frame2];
    testHttpsLabel.text = @"开启HTTPS";
    testHttpsLabel.backgroundColor  = [UIColor clearColor];
    testHttpsLabel.font = [UIFont systemFontOfSize:15];
    [testHttpsLabel setFrame:frame2];
    [self.view addSubview:testHttpsLabel];

    self.testHttpsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(testHttpsLabel.frame.origin.x + testHttpsLabel.frame.size.width,
                                                                      testHttpsLabel.frame.origin.y,
                                                                      50, 30)];

    [self.testHttpsSwitch setOn:self.isTestHttps animated:YES];
    [self.testHttpsSwitch addTarget:self action:@selector(clickTestHttpsSlider:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.testHttpsSwitch];

    /*
    CGRect frame3 = testHttpsLabel.frame;
    frame3.origin.y += frame3.size.height + 10;
    frame3.size.width += 30;
    UILabel *testAdServerLabel = [[UILabel alloc] initWithFrame:frame3];
    testAdServerLabel.text = @"开启广告测试环境";
    testAdServerLabel.backgroundColor  = [UIColor clearColor];
    testAdServerLabel.font = [UIFont systemFontOfSize:15];
    [testAdServerLabel setFrame:frame3];
    [self.view addSubview:testAdServerLabel];


    self.testAdServerSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(testAdServerLabel.frame.origin.x + testAdServerLabel.frame.size.width,
                                                                         testAdServerLabel.frame.origin.y,
                                                                         50, 30)];

    [self.testAdServerSwitch setOn:self.isUseAdTestingServer animated:YES];
    [self.testAdServerSwitch addTarget:self action:@selector(clickTestAdServerSlider:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.testAdServerSwitch];
    */


    self.h5TestButton = [[UIButton alloc] initWithFrame:CGRectMake(10, self.testHttpsSwitch.frame.origin.y + self.testHttpsSwitch.frame.size.height + 15, __MainScreen_Width/2 - 20, 30)];
    [self.h5TestButton setBackgroundColor:[UIColor grayColor]];
    [self.h5TestButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.h5TestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.h5TestButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.h5TestButton setTitle:@"H5-JSBridge" forState:UIControlStateNormal];
    [self.h5TestButton addTarget:self action:@selector(clickH5Button:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.h5TestButton];



    self.testCleanButton = [[UIButton alloc] initWithFrame:CGRectMake(10, self.h5TestButton.frame.origin.y + self.h5TestButton.frame.size.height + 15, __MainScreen_Width - 20, 30)];
    [self.testCleanButton setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.4]];
    [self.testCleanButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.testCleanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.testCleanButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.testCleanButton setTitle:@"清除设置" forState:UIControlStateNormal];
    [self.testCleanButton addTarget:self action:@selector(clickTestCleanButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.testCleanButton];

    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.testCleanButton.frame.origin.y + self.testCleanButton.frame.size.height + 5, __MainScreen_Width - 20, 50)];
    [self.tipLabel setFont:[UIFont systemFontOfSize:13]];
    [self.tipLabel setTextAlignment:NSTextAlignmentCenter];
    [self.tipLabel setNumberOfLines:0];
    [self.view addSubview:self.tipLabel];
    [self updateTipLabel];
    /*
    UIButton *ActivityCleanButton = [[UIButton alloc] initWithFrame:CGRectMake(10, self.tipLabel.sy_bottom + 10, __MainScreen_Width - 20, 30)];
    [ActivityCleanButton setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.4]];
    [ActivityCleanButton setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
    [ActivityCleanButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [ActivityCleanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [ActivityCleanButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [ActivityCleanButton setTitle:@"清除会员活动设置" forState:UIControlStateNormal];
    [ActivityCleanButton addTarget:self action:@selector(clickVipActivityCleanButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ActivityCleanButton];

    UIButton *logoutbtn = [[UIButton alloc] initWithFrame:CGRectMake(10, ActivityCleanButton.sy_bottom + 10, __MainScreen_Width - 20, 30)];
    [logoutbtn setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.4]];
    [logoutbtn setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
    [logoutbtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [logoutbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [logoutbtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [logoutbtn setTitle:@"退出登陆" forState:UIControlStateNormal];
    [logoutbtn addTarget:self action:@selector(clicklogoutButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutbtn];

    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, logoutbtn.frame.origin.y + logoutbtn.frame.size.height + 5, __MainScreen_Width - 20, 50)];
    [timeLabel setFont:[UIFont systemFontOfSize:13]];
    [timeLabel setTextAlignment:NSTextAlignmentCenter];
    [timeLabel setNumberOfLines:1];
    timeLabel.text = [NSString stringWithFormat:@"打包时间戳 : %s %s",__DATE__,__TIME__];
    [self.view addSubview:timeLabel];
     */

    /*
    self.useHardDecodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, logoutbtn.frame.origin.y + logoutbtn.frame.size.height + 5, __MainScreen_Width - 20, 50)];
    [self.useHardDecodeLabel setFont:[UIFont systemFontOfSize:14]];
    [self.useHardDecodeLabel setTextAlignment:NSTextAlignmentLeft];
    [self.useHardDecodeLabel setText:@"使用硬解码"];
    [self.view addSubview:self.useHardDecodeLabel];

    self.useHardDecodeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, self.useHardDecodeLabel.frame.origin.y, 50, 30)];
    [self.useHardDecodeSwitch setOn:NO];
    [self.useHardDecodeSwitch addTarget:self action:@selector(clickedUseHardDecode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.useHardDecodeSwitch];
     */
    /*
    UILabel *locationLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.useHardDecodeSwitch.frame) + 20, 100, 30)];
    locationLbl.text = @"当前地域：";
    locationLbl.font = [UIFont systemFontOfSize:16];
    locationLbl.backgroundColor = [UIColor clearColor];
    locationLbl.textColor = [UIColor blackColor];
    [self.view addSubview:locationLbl];

    //  数据源
    self.cityInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kTestLocationGeocoder];
    NSArray * dmArray2 = [NSArray arrayWithObjects:@"未知",@"北京市|朝阳区",@"河北省|唐山市",@"内蒙古|鄂尔多斯市",@"山西省|临汾市",@"吉林省|延边州", nil];
    self.cityDropMenu = [[DMDropDownMenu alloc] initWithFrame:CGRectMake(CGRectGetMaxX(locationLbl.frame) + 5, CGRectGetMaxY(self.useHardDecodeSwitch.frame) + 20 , 200, 30)];
    [self.cityDropMenu setTitle:@"当前地域："];
    self.cityDropMenu.delegate = self;
    [self.cityDropMenu setListArray:dmArray2];
    [self.view addSubview:self.cityDropMenu];
    if (self.cityInfo && [self.cityInfo objectForKey:@"location"]) {
        [self.cityDropMenu setCurSelectItem:[self.cityInfo objectForKey:@"location"]];
    }else{
        [self.cityDropMenu setCurSelectItem:@"未知"];
    }
     */

}

- (void)setMyTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.text = title;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor sy_colorWithHexString:@"#000000"];
    self.navigationItem.titleView = titleLabel;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 36, 44);
    [back setImage:[UIImage imageNamed_sy:@"voiceroom_back"]
          forState:UIControlStateNormal];
    [back addTarget:self
             action:@selector(back:)
   forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
}


- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)clicklogoutButton{

}
/*
- (void)clickVipActivityCleanButton:(id)sender{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"kLetvFirstInstallVersion" accessGroup:nil];
    [keychainItem resetKeychainItem];

    KeychainItemWrapper *keychainItem2 = [[KeychainItemWrapper alloc] initWithIdentifier:@"kLetvRecievedVIPResult" accessGroup:nil];
    [keychainItem2 resetKeychainItem];

    KeychainItemWrapper *keychainItem3 = [[KeychainItemWrapper alloc] initWithIdentifier:@"UUID" accessGroup:nil];
    [keychainItem3 resetKeychainItem];
    NSString *firstInstallVersion3 = [keychainItem3 objectForKey:(__bridge id)kSecValueData];

    NSString *versionFileName = @"version.info";
    NSString *versionFilePath = [[FileManager appLetvProtectedPath] stringByAppendingPathComponent:versionFileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:versionFilePath]) {
        [FileManager deleteFileWithPath:versionFilePath];
    }
    [SettingManager saveBoolValueToUserDefaults: NO
                                         ForKey: KHasShowedTrialView];
}
 */
- (void)clickTestSlider:(id)sender {
    [SYSettingManager setSyTestApi:self.testSwitch.on];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setBool:self.testSwitch.on forKey:kTestAPIKey];
//    [defaults synchronize];
    [self updateTipLabel];
}

- (void)clickHKTestSlider:(id)sender
{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setBool:self.testHKSwitch.on forKey:kHKTestAPIKey];
//    [defaults synchronize];
}


- (void)clickTestHttpsSlider:(id)sender
{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setBool:self.testHttpsSwitch.on forKey:kTestHttpsKey];
//    [defaults synchronize];
//    [self updateTipLabel];
}

- (void)clickTestAdServerSlider:(id)sender
{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setBool:self.testAdServerSwitch.on forKey:kUseAdTestingServer];
//    [defaults synchronize];
//    [self updateTipLabel];
}


- (void)clickTestCleanButton:(id)sender
{
#ifdef UseSettingTestDevEnv
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"kTestAPIKey"];
    [defaults removeObjectForKey:@"sy_need_info"];
//    [defaults removeObjectForKey:kHKTestAPIKey];
//    [defaults removeObjectForKey:kTestHttpsKey];
//    [defaults removeObjectForKey:kTestLocationGeocoder];
//    [defaults removeObjectForKey:kUseAdTestingServer];
    [defaults synchronize];

    [self.testSwitch setOn:NO animated:YES];
//    [self.testHKSwitch setOn:NO animated:YES];
    [self.testHttpsSwitch setOn:NO animated:YES];
//    [self.testAdServerSwitch setOn:NO animated:YES];
//    [self.cityDropMenu setCurSelectItem:@"未知"];
    self.isTestApi = NO;
//    self.isHKTestApi = NO;
    self.isTestHttps = NO;
//    self.isUseAdTestingServer = NO;
//    self.cityInfo = nil;
    [self updateTipLabel];
#endif
}


- (void)clickH5Button:(id)sender {
    SYTestWebViewController *vc = [[SYTestWebViewController alloc]initWithURL:@"https://mp.le.com/sy/w/jsbridge" andTitle:@"" andRoomId:@"10001"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickedUseHardDecode:(id)sender
{
//    [SettingManager setUseHardDecodePlayer:![SettingManager isUseHardDecodePlayer]];
}

- (void)updateTipLabel
{
    NSString *tipString = @"点击清除设置后就会以服务器配置的环境为准\n当前状态: ";
#ifdef UseSettingTestDevEnv
        tipString = [tipString stringByAppendingString:@"本地控制"];
        BOOL isTest = [SYSettingManager syIsTestApi];
        if (isTest) {
            tipString = [tipString stringByAppendingString:@", 测试环境"];
        } else {
            tipString = [tipString stringByAppendingString:@", 正式环境"];
        }
#else
        tipString = [tipString stringByAppendingString:@"服务器控制"];
        BOOL isTest = NO;//[SettingManager isTestApi];
        if (isTest) {
            tipString = [tipString stringByAppendingString:@", 测试环境"];
        } else {
            tipString = [tipString stringByAppendingString:@", 正式环境"];
        }
#endif

#ifdef UseSettingTestDevEnv
        tipString = [tipString stringByAppendingString:@",HTTPS 本地控制"];
        BOOL isHTest = NO;//[[NSUserDefaults standardUserDefaults] boolForKey:kTestHttpsKey];
        if (isHTest) {
            tipString = [tipString stringByAppendingString:@": https环境"];
        } else {
            tipString = [tipString stringByAppendingString:@": http环境"];
        }
#else
        tipString = [tipString stringByAppendingString:@",HTTPS服务器控制"];
        BOOL isHTest = NO;//[SettingManager isSupportHTTPS];
        if (isHTest) {
            tipString = [tipString stringByAppendingString:@": https环境"];
        } else {
            tipString = [tipString stringByAppendingString:@": http环境"];
        }
#endif


//    BOOL isTesting = [[NSUserDefaults standardUserDefaults] boolForKey:kUseAdTestingServer];
//    if (isTesting) {
//        tipString = [tipString stringByAppendingString:@", 广告服务器: 测试环境"];
//    } else {
//        tipString = [tipString stringByAppendingString:@", 广告服务器: 线上环境"];
//    }

    [self.tipLabel setText:tipString];
}

/*
- (void)selectIndex:(NSInteger)index AtDMDropDownMenu:(DMDropDownMenu *)dmDropDownMenu
{
    NSArray *list = dmDropDownMenu.listArr;
    if (index >= list.count) {
        return;
    }
    NSDictionary *curDict = nil;
    NSString *city = [list objectAtIndex:index];
    if ([city isEqualToString:@"北京市|朝阳区"]) {
        curDict = @{@"country":@"CN",@"provinceid":@"1",@"districtid":@"9",@"citylevel":@"1",@"location":@"北京市|朝阳区"};
    }else if([city isEqualToString:@"河北省|唐山市"]){
        curDict = @{@"country":@"CN",@"provinceid":@"3",@"districtid":@"38",@"citylevel":@"2",@"location":@"河北省|唐山市"};
    }else if([city isEqualToString:@"内蒙古|鄂尔多斯市"]){
        curDict = @{@"country":@"CN",@"provinceid":@"5",@"districtid":@"33",@"citylevel":@"3",@"location":@"内蒙古|鄂尔多斯市"};
    }else if([city isEqualToString:@"山西省|临汾市"]){
        curDict = @{@"country":@"CN",@"provinceid":@"4",@"districtid":@"57",@"citylevel":@"4",@"location":@"山西省|临汾市"};
    }else if([city isEqualToString:@"吉林省|延边州"]){
        curDict = @{@"country":@"CN",@"provinceid":@"7",@"districtid":@"93",@"citylevel":@"5",@"location":@"吉林省|延边州"};
    }
    if (curDict) {
        self.cityInfo = curDict;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:curDict forKey:kTestLocationGeocoder];
        [defaults synchronize];
    }
}
 */

@end
