//
//  CustomAlertView.m
//  tonghetang
//
//  Created by ZSY on 2018/6/13.
//

#import "CustomAlertView.h"

@interface CustomAlertView()<CAAnimationDelegate>
@end

@implementation CustomAlertView
{
    __weak IBOutlet UIView *_alertView;
    CABasicAnimation *_animation;
    CGRect _frame;
}

+(instancetype)LoadXibView
{
    CustomAlertView *alertView = [[NSBundle mainBundle] loadNibNamed:@"CustomAlertView" owner:nil options:nil].firstObject;
    alertView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    alertView.hidden = YES;
    return alertView;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)showAlertView
{
    if(_animation){
        return;
    }
    if(self.superview){
        self.frame = _frame = self.superview.bounds;
//        self.layer.anchorPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        //8500/30*23+6800/30*7
        self.hidden = NO;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithInt:0.00001];
    animation.toValue = [NSNumber numberWithInt:1];
    animation.duration = 0.2;
    animation.repeatCount = 1;
    animation.delegate = self;
    [_alertView.layer addAnimation:animation forKey:@"showAnimation"];
    _animation = animation;
}

-(void)hideAnimation
{
    if(_animation){
        return;
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithInt:1];
    animation.toValue = [NSNumber numberWithInt:0.00001];
    animation.duration = 0.2;
    animation.repeatCount = 1;
    animation.delegate = self;
    [_alertView.layer addAnimation:animation forKey:@"hideAnimation"];
    _animation = animation;
    _frame = CGRectZero;
}

#pragma mark CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    _animation = nil;
    if(CGRectIsEmpty(_frame)){
        self.hidden = YES;
    }
}

#pragma mark touchEvent
- (IBAction)phoneNumLogin:(id)sender {
    
    if(_phoneLoginBlock){
        _phoneLoginBlock();
    }
}
- (IBAction)changePhoneNum:(id)sender {
    
    if(_changePhoneBlock){
        _changePhoneBlock();
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self hideAnimation];
}

@end
