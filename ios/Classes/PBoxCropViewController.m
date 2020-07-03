#import <UIKit/UIKit.h>
#import "PBoxCropViewController.h"

#import "UIImage+CropRotate.h"

@interface PBoxCropViewController ()

@property (nonatomic, readwrite) TOCropView *cropView;

@end

@implementation PBoxCropViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *blackColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.18 alpha:1];
    UIColor *greenColor = [UIColor colorWithRed:0.56 green:0.78 blue:0.25 alpha:1];
    
    //        [[UINavigationBar appearance] setBarTintColor:color];
    //        [[UINavigationBar appearance] setTranslucent:NO];
    self.navigationController.navigationBar.barTintColor = blackColor;
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed)];
    self.navigationItem.rightBarButtonItem.tintColor = greenColor;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)];
    self.navigationItem.leftBarButtonItem.tintColor = UIColor.whiteColor;

    self.title = @"EDIT";
    
    BOOL smallScreen = UIScreen.mainScreen.bounds.size.height <= 568;
    CGFloat cropViewOffset = smallScreen ? 48.0 : 72.0;
    //        if isPhoneX {
    //            switch performedBy {
    //            case .system: cropViewOffset = 72.0
    //            case .user: cropViewOffset = 0
    //            }
    //        }
    
    UIView *cropContainerView = self.view;
    // Prepare new image's crop view
    self.cropView = [[TOCropView alloc] initWithImage:self.image];
    //        cropView.backgroundColor = UIColor(hex: 0x535353)
    self.cropView.aspectRatio = CGSizeMake(1, 1);
    self.cropView.aspectRatioLockEnabled = true;
    self.cropView.resetAspectRatioEnabled = false;
    self.cropView.frame = CGRectMake(
                                     cropContainerView.bounds.origin.x,
                                     -cropViewOffset,
                                     cropContainerView.frame.size.width,
                                     cropContainerView.frame.size.height + cropViewOffset
                                     );
    //        cropView.imageCropFrame = viewModel.currentPhoto.cropRect
    //        cropView.angle = viewModel.currentPhoto.cropAngle
    [self.cropView performInitialSetup];
    
    // Add new crop view to the cropContainerView as subview
    [self.view addSubview:self.cropView];
    
}

- (void)savePressed {
    NSLog(@"savePressedFoo");
    CGRect cropFrame = self.cropView.imageCropFrame;
    NSInteger angle = self.cropView.angle;

    UIImage *image = nil;
    if (angle == 0 && CGRectEqualToRect(cropFrame, (CGRect){CGPointZero, self.image.size})) {
        image = self.image;
    }
    else {
        image = [self.image croppedImageWithFrame:cropFrame angle:angle circularClip:NO];
    }
    
    // doing this makes it so I have to change less of the original plugin
    id<TOCropViewControllerDelegate> delegatePlugin = (id<TOCropViewControllerDelegate>)self.plugin;
    [delegatePlugin cropViewController:self didCropToImage:image withRect:cropFrame angle:angle];
}

- (void)backPressed {
    NSLog(@"backPressedFoo");
    [self dismissViewControllerAnimated:YES completion:nil];

    [self.plugin deliverResult:nil];
}

//    var isPhoneX: Bool {
//        return UIScreen.main.bounds.height == 812.0
//    }
@end
