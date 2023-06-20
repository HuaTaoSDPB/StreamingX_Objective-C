//
//  LookUpImagesViewController.m
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/14.
//

#import "LookUpImagesViewController.h"
#import <SDWebImage/SDWebImage.h>

@interface LookUpImagesViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation LookUpImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*self.model.others.count, self.scrollView.bounds.size.height);
    self.scrollView.delegate = self;
    for (NSInteger i = 0; i < self.model.others.count; i ++) {
        UIImageView * imageV = [UIImageView new];
        imageV.frame = CGRectMake(self.scrollView.bounds.size.width*i, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.clipsToBounds = YES;
        [imageV sd_setImageWithURL:[NSURL URLWithString:self.model.others[i].avatarStandard]];
        [self.scrollView addSubview:imageV];
    }
}

- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x/self.view.bounds.size.width;
    self.pageLabel.text = [NSString stringWithFormat:@"%@/%@",@(page+1),@(self.model.others.count)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
