#import "ImageCropperPlugin.h"
#import <TOCropViewController/TOCropViewController.h>

@interface PBoxCropViewController : UIViewController

@property (nonatomic, readwrite) UIImage *image;
@property (nonatomic, weak) FLTImageCropperPlugin *plugin;

@end
