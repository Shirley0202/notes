#pragma mark 数组排序1  
void arraySort1() {  
    NSArray *array = [NSArray arrayWithObjects:@"2", @"3", @"1", @"4", nil nil];  
      
    // 返回一个排好序的数组，原来数组的元素顺序不会改变  
    // 指定元素的比较方法：compare:  
    NSArray *array2 = [array sortedArrayUsingSelector:@selector(compare:)];  
    NSLog(@"array2:%@", array2);  
}  
  
#pragma mark 数组排序2  
void arraySort2() {  
    Student *stu1 = [Student studentWithFirstname:@"MingJie" lastname:@"Li"];  
    Student *stu2 = [Student studentWithFirstname:@"LongHu" lastname:@"Huang"];  
    Student *stu3 = [Student studentWithFirstname:@"LianJie" lastname:@"Li"];  
    Student *stu4 = [Student studentWithFirstname:@"Jian" lastname:@"Xiao"];  
    NSArray *array = [NSArray arrayWithObjects:stu1,stu2,stu3, stu4, nil nil];  
    // 指定排序的比较方法  
    NSArray *array2 = [array sortedArrayUsingSelector:@selector(compareStudent:)];  
    NSLog(@"array2:%@", array2);  
}  
- (NSComparisonResult)compareStudent:(Student *)stu {  
    // 先按照姓排序  
    NSComparisonResult result = [self.lastname compare:stu.lastname];  
    // 如果有相同的姓，就比较名字  
    if (result == NSOrderedSame) {  
        result = [self.firstname compare:stu.firstname];  
    }  
    return result;  
}  
  
#pragma mark 数组排序3  
void arraySort3() {  
    Student *stu1 = [Student studentWithFirstname:@"MingJie" lastname:@"Li"];  
    Student *stu2 = [Student studentWithFirstname:@"LongHu" lastname:@"Huang"];  
    Student *stu3 = [Student studentWithFirstname:@"LianJie" lastname:@"Li"];  
    Student *stu4 = [Student studentWithFirstname:@"Jian" lastname:@"Xiao"];  
    NSArray *array = [NSArray arrayWithObjects:stu1,stu2,stu3, stu4, nil nil];  
      
    // 利用block进行排序  
    NSArray *array2 = [array sortedArrayUsingComparator:  
     ^NSComparisonResult(Student *obj1, Student *obj2) {  
         // 先按照姓排序  
         NSComparisonResult result = [obj1.lastname compare:obj2.lastname];  
         // 如果有相同的姓，就比较名字  
         if (result == NSOrderedSame) {  
             result = [obj1.firstname compare:obj2.firstname];  
         }  
           
         return result;  
    }];  
      
    NSLog(@"array2:%@", array2);  
}  
  
#pragma mark 数组排序4-高级排序  
void arraySort4() {  
    Student *stu1 = [Student studentWithFirstname:@"MingJie" lastname:@"Li" bookName:@"book1"];  
    Student *stu2 = [Student studentWithFirstname:@"LongHu" lastname:@"Huang" bookName:@"book2"];  
    Student *stu3 = [Student studentWithFirstname:@"LianJie" lastname:@"Li" bookName:@"book2"];  
    Student *stu4 = [Student studentWithFirstname:@"Jian" lastname:@"Xiao" bookName:@"book1"];  
    NSArray *array = [NSArray arrayWithObjects:stu1,stu2,stu3, stu4, nil nil];  
      
    // 1.先按照书名进行排序  
    // 这里的key写的是@property的名称  
    NSSortDescriptor *bookNameDesc = [NSSortDescriptor sortDescriptorWithKey:@"book.name" ascending:YES];  
    // 2.再按照姓进行排序  
    NSSortDescriptor *lastnameDesc = [NSSortDescriptor sortDescriptorWithKey:@"lastname" ascending:YES];  
    // 3.再按照名进行排序  
    NSSortDescriptor *firstnameDesc = [NSSortDescriptor sortDescriptorWithKey:@"firstname" ascending:YES];  
    // 按顺序添加排序描述器  
    NSArray *descs = [NSArray arrayWithObjects:bookNameDesc, lastnameDesc, firstnameDesc, nil nil];  
      
    NSArray *array2 = [array sortedArrayUsingDescriptors:descs];  
      
    NSLog(@"array2:%@", array2);  
} 