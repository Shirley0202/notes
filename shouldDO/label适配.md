# 以前总是很烦设计师非要说，让『把行距调大一点点』，因为在 iOS 这个对文字处理各种不友好的系统里，改行距并不像改字号那么简单，只调『一点点』也得多写好几行。
不过自从我写了下面这些工具方法，调行距也就回归到它本来应该的样子：一行代码的事。

设置行距

UILabel+Utils.m

- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing {
    if (lineSpacing < 0.01 || !text) {
        self.text = text;
        return;
    }

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];

    self.attributedText = attributedString;
}
使用

[label setText:text lineSpacing:2.0f];
作为一个四处使用的工具方法，前面的nil检查很有必要加。因为[[NSMutableAttributedString alloc] initWithString:text] 不接受 nil 参数，会直接 crash。
生成的 paragraphStyle 除了配行距之外，还带上了 label 原有的一些常用属性。如果有其他需要，也可以加在这里。
UITextView+Utils.m

- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing {
    if (lineSpacing < 0.01 || !text) {
        self.text = text;
        return;
    }

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedText length])];

    self.attributedText = attributedString;
}
UITextView 的方法跟 UILabel 基本一样。

使用

[textView setText:text lineSpacing:2.0f];
计算行高

自定义行距之后，计算文本高度的方法也得相应改。很简单，只要利用 sizeToFit、sizeThatFits 之类的方法就可以了。

UILabel+Utils.m

+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, MAXFLOAT)];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = 0;
    [label setText:text lineSpacing:lineSpacing];
    [label sizeToFit];
    return label.height;
}
UITextView+Utils.m

+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing {
    UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, MAXFLOAT)];
    textView.font = [UIFont systemFontOfSize:fontSize];
    [textView setText:text lineSpacing:lineSpacing];
    [textView sizeToFit];
    return textView.height;
}
因为默认的 UITextView 有一点 inset，所以计算文本高度的方法要跟 UILabel 分开。

这几个方法就能应付大多数需求了。根据自己需要，我还写了一些参数带有 numberOfLines、文本的参数为 attributedString 的变体。

代码上的行距 vs 设计图上的行距

如果只为贴上面几个方法，我可能也就懒得写这篇文章了。这篇文章的重点其实是分享下面这一点：代码传参数进去的行距与设计图上量出来的行距是有区别的，代码上要少几个像素，而减少的量跟字体大小有关。

我感觉这一点有时容易被人忽视。例如一个 UILabel 字号为14，有些程序员可能就会把这个 Label 高度定为 14 像素了。而经验丰富的人就会知道不能这样，否则『h』『g』之类的字母都可能会被切掉一些。在 xib 里，选中 label 之后按『Command + =』会发现字号为 14 的 label 合适的高度应该是 17。

为了给像『g』、『y』英文字母的尾巴留出空间，系统会给 UILabel 上的文字上下加一点默认的空白，这就是 font size 与 line height 的区别。而用代码设定paragraphStyle的lineSpacing，是叠加在原有空白之上的。

别小看这点空白。如果设计师没有丧心病狂，设计出的行距往往也就是 4、5 个像素，而对 14 号字来说上下两行的空白就能占到 3 像素。如果不假思索地直接把设计图的标注传进去，结果就是行距放大到150%。视觉上出了偏差，我们也要负责任的。


行距组成示意图
由图所示，视觉上的行距其实由那 3 部分组成：上面一行的默认空白 + 行距 + 下面一行的默认空白。蓝色高度是我们写的 lineSpacing，而黄色和绿色加起来正好是一倍font.lineHeight - font.pointSize的值（黄色高度是上面一行的一半，为(font.lineHeight - font.pointSize) / 2，绿色是下面一行的一半）。

简单打下 log 就可以看到这个差值大概是多少。下面列出常见的字号：

font size	| font.lineHeight（近似）|	差值
------ | ------- | ------
10	|12|	2
11	|13	|2
12	|14	|2
13	|15.5	|2.5
14	|17	|3
15	|18	|3
16	|19	|3
17	|20	|3
18	|21.5	|3.5
19	|23	|4
20	|24	|4
为了计算效率高，我们就不在运行时现算这个差值了；直接把设计图上量出的行距减去上面这个表里几个像素的差值，作为参数传进去即可。例如：14 号字的 label，设计图上量出的行距是 5 个像素，那就减去 3 个像素，写[label setText:text lineSpacing:2.0f];。不要忘了计算行高的时候也要用同样的参数~

