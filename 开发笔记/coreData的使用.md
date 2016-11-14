1. coreData是封装的sqlist  

一个模型      就是一个数据库    一个数据库需要一个上下文
一个实体      就是一张表     
一个实体类    就是一个模型  都是NSManagedObject类型的 




//可是设置一对多 表于表之间可以相互的关联

    
###创建一个模型对象// 传一个nil 会把 bundle下的所有模型文件 关联起来
 NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    
    
###创建存储调度器 持久化 存储 调度器 关联一个 "模型""

NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

 获取docment目录
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
 数据库保存的路径
    NSString *sqlitePath = [doc stringByAppendingPathComponent:@"company.sqlite"];
    
 给调度器配置一些东西 包括存储的位置
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:&error];

###需要一个上下文 (配置上需要的 存储调度器)
 NSManagedObjectContext *context =[[NSManagedObjectContext alloc] init];
 
context.persistentStoreCoordinator = store;


//其他的这些简单的操作都需要上下文

###增  

   Employee *emp1 = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:self.context];
        
        // 设置员工属性
        emp1.name = [NSString stringWithFormat:@"wangwu %d",i];
        emp1.age = @(28 + i);
        emp1.height = @2.10;
        
        //保存 - 通过上下文操作
        NSError *error = nil;
        [self.context save:&error];
        if (!error) {
            NSLog(@"success");
        }else{
            NSLog(@"%@",error);
        }


###删 

     // 删除zhangsan
    // 1.查找到zhangsan
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name=%@",name];
    request.predicate = pre;
    
    // 2.删除zhangsan
    NSArray *emps = [self.context executeFetchRequest:request error:nil];
    
    for (Employee *emp in emps) {
        NSLog(@"删除员工的人 %@",emp.name);
        [self.context deleteObject:emp];
    }
    
    // 3.用context同步下数据库
    //所有的操作暂时都是在内存里，调用save 同步数据库
    [self.context save:nil];

###改
#pragma mark 更新员工信息


    - (IBAction)updateEmployee:(id)sender {
    
    // 把wangwu的身高更改成 1.7
    // 1.查找wangwu
    NSArray *emps = [self findEmployeeWithName:@"wangwu"];
    
    // 2.更新身高
    if (emps.count == 1) {
        Employee *emp = emps[0];
        emp.height = @1.7;
    }
    
    // 3.同步（保存）到数据
    [self.context save:nil];
    }

    -(NSArray *)findEmployeeWithName:(NSString *)name{
    // 1.查找员工
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name=%@",name];
    request.predicate = pre;
    
    
    return [self.context executeFetchRequest:request error:nil];
    
}


###查  (改和删都是先在查的基础上来操作的,先查到对应的数据之后再对其进行操作)



#pragma mark 读取员工信息
    - (IBAction)readEmployee:(id)sender {
    
    //创建一个请求对象 （填入要查询的表名-实体类）
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    // 过滤查询
    // 查找张三 并且身高大于1.8
    //    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name=%@ AND height > %@",@"zhangsan",@(1.8)];
    //    request.predicate = pre;
    
    //排序 以身高进行升序
    //    NSSortDescriptor *sort = [NSSortDescriptor    sortDescriptorWithKey:@"height" ascending:NO];
    //    request.sortDescriptors = @[sort];
    
    // 分页查询 总共13条数据 每页显示5条数据
    //第一页的数据
    request.fetchLimit = 5;
    request.fetchOffset = 10;
    
    
    //读取信息
    NSError *error = nil;
    NSArray *emps = [self.context executeFetchRequest:request error:&error];
    if (!error) {
        NSLog(@"emps: %@",emps);
        for (Employee *emp in emps) {
            NSLog(@"%@ %@ %@",emp.name,emp.age,emp.height);
        }
    }else{
        NSLog(@"%@",error);
    }
    }



###问题
1.已经创建好的 模型 无法在更改拉 需要特定的语句


coredata 总结 更加具有实用型,	可以是使用MegicalRecord 第三方的框架,主要还是在于建表, coredata中是重要的几个类:NSManagerObjectContext(上下文)    NSManageObject(模型类) NSManagerObjectMode(型类) NSPersistentStoreCoordinator(持久化存储调度器)  NSFetchRequest(获取数据请求类)  (参考MJ博客) 简单的增删改查
