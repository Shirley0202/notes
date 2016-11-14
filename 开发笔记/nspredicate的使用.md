
##NSPredicate的使用 
> Cocoa框架中的NSPredicate用于查询，原理和用法都类似于SQL中的where，作用相当于数据库的过滤取。(就是一个比较的条件可用于很多的比较中,尤其对数组的操作)

self  值的是使用这个NSPredicate的对象 

```
//创建一个谓词
NSPredicate *ca = [NSPredicate predicateWithFormat:(NSString *), ...];  
```




#### 具体的使用如下   Format：
##### 1.比较运算符>,<,==,>=,<=,!=可用于数值及字符串 例：@"number > 100"

```
  NSArray *array = [NSArray arrayWithObjects:@1,@2,@3,@4,@5,@2,@6, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF >4"];
    NSArray *fliterArray = [array filteredArrayUsingPredicate:predicate];
    [fliterArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"fliterArray = %@",obj);
    }];
```
##### 2.范围运算符：IN、BETWEEN：@"number BETWEEN {1,5}" @"address IN {'shanghai','beijing'}"


```
 NSArray *array = [NSArray arrayWithObjects:@1,@2,@3,@4,@5,@2,@6, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF in {2,5}"]; //找到 in 的意思是array中{2,5}的元素
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BETWEEN {2,5}"];
    NSArray *fliterArray = [array filteredArrayUsingPredicate:predicate];
    [fliterArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"fliterArray = %@",obj);
    }];
```
##### 3.字符串本身:SELF 例：@“SELF == ‘APPLE’"


``` 
NSArray *placeArray = [NSArray arrayWithObjects:@"Shanghai",@"Hangzhou",@"Beijing",@"Macao",@"Taishan", nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == 'Beijing'"];
    NSArray *tempArray = [placeArray filteredArrayUsingPredicate:predicate];
    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"obj == %@",obj);
    }];
    
```
##### 4字符串相关：BEGINSWITH、ENDSWITH、CONTAINS例：@"name CONTAIN[cd] 'ang'"   //包含某个字符串@"name BEGINSWITH[c] 'sh'"     //以某个字符串开头 @"name ENDSWITH[d] 'ang'"      //以某个字符串结束
    注:[c]不区分大小写[d]不区分发音符号即没有重音符号[cd]既不区分大小写，也不区分发音符号。

```

   NSArray *placeArray = [NSArray arrayWithObjects:@"Shanghai",@"Hangzhou",@"Beijing",@"Macao",@"Taishan", nil];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS [cd] 'an' "];
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF Beginswith [cd] 'sh' "];
 NSArray *tempArray = [placeArray filteredArrayUsingPredicate:predicate1];
    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"obj == %@",obj);
    }];
```
##### 5通配符：LIKE例：@"name LIKE[cd] '*er*'"  //*代表通配符,Like也接受[cd].    @"name LIKE[cd] '???er*'"

```
 NSArray *placeArray = [NSArray arrayWithObjects:@"Shanghai",@"Hangzhou",@"Beijing",@"Macao",@"Taishan", nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF  like '*ai*' "];
    
    NSArray *tempArray = [placeArray filteredArrayUsingPredicate:predicate];
    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"obj == %@",obj);
    }];
```

#####6正则表达式：MATCHES例：NSString *regex = @"^A.+e$";   //以A开头，e结尾  @"name MATCHES %@",regex  (还是用于其他的正则表达式,)

```

    NSString *regex = @"^A.+e$";   //以A开头，e结尾  @"name MATCHES %@",regex
    NSPredicate *presdicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    NSString *content = @"Alkdjflse";
   BOOL result = [presdicate evaluateWithObject:content];
    NSLog(@"%d",result);
    
```

> 匹配手机号码

```
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
        {
            if([regextestcm evaluateWithObject:mobileNum] == YES) {
                NSLog(@"China Mobile");
            } else if([regextestct evaluateWithObject:mobileNum] == YES) {
                NSLog(@"China Telecom");
            } else if ([regextestcu evaluateWithObject:mobileNum] == YES) {
                NSLog(@"China Unicom");
            } else {
                NSLog(@"Unknow");
            }
        
            return YES;
        }
    else
        {
            return NO;
        }
}

```

###NSPredicate的强大的能力，作为正则表达式的核心类，确实优化了很多的字符串及其正则相关的操作的流程。使代码简洁，而强大！
>最主要就是能够写出合适的 Format 


#### 7对于数组中的是自定义的对象,predicate也是同样可以使用,对于上面的使用规则一样可以使用 简单的介绍如下 还有更多强大的功能

```

 Car *car =[[Car alloc]init];
    car.name =@"mazida";
    car.age =10;
    Car *car1 =[[Car alloc]init];
    car1.name =@"baoma";
    car1.age =11;
    Car *car2 =[[Car alloc]init];
    car2.name =@"benchi";
    car2.age = 12;
    NSArray *cars =@[car,car1,car2];
    //基本的查询
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat: @"SELF.age > 12"];
    BOOL match = [predicate evaluateWithObject: car];
    NSLog(@"%d",match);
    NSArray *result =[cars filteredArrayUsingPredicate:predicate];
    NSLog(@"%@",result);
    //在整个cars里面循环比较
    predicate = [NSPredicate predicateWithFormat: @"age > 10"];
    for (Car *car in cars) {
        if ([predicate evaluateWithObject: car]) {
            NSLog (@"%@", car.name);
        }
    }
```

>


