###UIMenuController 用来显示一个系统的菜单,可以自定义里面的内容
####系统的一些控件默认是支持的,例如UITextField UITxetView UiWebView 


 - 要想让其他控件也支持UIMenucontroller需要如下条件
    
    1.这个控件能够成为第一响应着 需要重写 -(BOOL)canBecomeFirstResponder
    
    2这个控件可以实现mune上的方法-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
    
    
 - 想要弹出MENU步骤 
   
   1.成为第一响应者
   2.创建menu,并弹出
   
- 想要自定义上面的按钮 可以使用 UIMenuItem类来创建 添加到UIMenuController 上面 但是响应的实现方法要写在控制器里面



     自定义一个label
     
        #import <UIKit/UIKit.h>
        @interface MyLabel : UILabel

        @end
        #import "MyLabel.h"

        @implementation MyLabel
        /**
         *  能够成为第一响应者
         */
        - (BOOL)canBecomeFirstResponder{
         return YES;
         }
		/**
		 *  可以执行menu的一下方法 注:返回YES的方法必须要实现
		 */
		- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
		    NSLog(@"%@",NSStringFromSelector(action));
		    if (action ==@selector(cut:)||action ==@selector(copy:)) {
		        return YES;
		    }
		    return NO;
		}
		#pragma mark - 实现MENU上的方法 
		/**
		 *  剪切
		 */
		- (void)cut:(UIMenuController *)sender{
		    [self copy:sender];
		    self.text =@"";
		}
		/**
		 *  复制到剪切板
		 */
		- (void)copy:(UIMenuController *)sender{
		    if (self.text.length<=0) return;
		    UIPasteboard *pasteboard =[UIPasteboard generalPasteboard];
		    pasteboard.string =self.text;
		}
		@end


   控制器里面的调用
   
   
   
   
        #import "ViewController.h"
		#import "MyLabel.h"
		@interface ViewController ()
		
		@property (weak, nonatomic) IBOutlet MyLabel *label;
		
		
		@end
		
		@implementation ViewController
		/**
		 *  UIMenuController 用来显示一个系统的菜单,可以自定义里面的内容, 步骤如下
		 *
		 */
	  - (void)viewDidLoad {
	    [super viewDidLoad];
        self.label.userInteractionEnabled =YES;
       [self.label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClicked)]];
    
        }
       -(void)labelClicked{
    
	    [self.label becomeFirstResponder];
	    
	    UIMenuController *menu =[UIMenuController sharedMenuController];
	    
	    [menu setTargetRect:self.label.bounds inView:self.label];
	    UIMenuItem *ding =[[UIMenuItem alloc]initWithTitle:@"顶" action:@selector(ding:)];
	    UIMenuItem *zan =[[UIMenuItem alloc]initWithTitle:@"赞" action:@selector(zan:)];
	    
	    
	    menu.menuItems =@[ding,zan];
	    [menu setMenuVisible:YES animated:YES];
	    
	    
	    }
	    -(void)ding:(id)sender{
	    
	      NSLog(@"%s",__func__);
	    
	    }
	     -(void)zan:(id)sender{
	    
	    NSLog(@"%s",__func__);
	    
	    }
	    @end
	















