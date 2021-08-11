//
//  interViewController.m
//  Player_Task
//
//  Created by 赵运泽 on 2021/8/4.
//

#import "interViewController.h"
#import "ViewController.h"
@interface interViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *files ;
}
@property (weak, nonatomic) IBOutlet UIButton *changeVideo;
@property (strong, nonatomic) IBOutlet UITableView *TableView;


@end

@implementation interViewController



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *BASE_PATH  = [NSBundle mainBundle].bundlePath;
    NSFileManager *myFileManager = [NSFileManager defaultManager];
        NSDirectoryEnumerator *myDirectoryEnumerator = [myFileManager enumeratorAtPath:BASE_PATH];
    //新建数组，存放各个文件路径
        files = [[NSMutableArray alloc] init];
        //遍历目录迭代器，获取各个文件路径
        NSString *filename;
        while (filename = [myDirectoryEnumerator nextObject]) {
            if ([[filename pathExtension] isEqualToString:@"mp4"] || [[filename pathExtension] isEqualToString:@"m4a"] || [[filename pathExtension] isEqualToString:@"mov"] || [[filename pathExtension] isEqualToString:@"m4v"]) {//筛选出文件后缀名是htm的文件
                [files addObject:filename];
            }
        }
    
    self.TableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    // 让控制器成为tableView的数据源代理和代理
    self.TableView.dataSource = self;
    self.TableView.delegate = self;
    // 注册cell和设置重用标识符
    [self.TableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    // 添加tableView到控制器的视图上
    [self.view addSubview:self.TableView];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 如果第一个分区显示行📖，第二个分区显示7行
    // 分区和行的索引跟数组是一样的，都默认从0开始
    return files.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", files[indexPath.row]];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(cell.frame.size.width-90,15, 70.0f, cell.frame.size.height-15)];
        btn.layer.cornerRadius = 7.0;
    [btn setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = indexPath.row;
        [cell.contentView addSubview:btn];

    return cell;
}
- (void)btnClicked:(UIButton *)sender{
     //NSString *filename = [files[sender.tag] stringByDeletingPathExtension];
    NSString *filename = files[sender.tag];
    ViewController* preview =[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    preview.videoID=filename;
    preview.videoNo=sender.tag;
    
    [self.navigationController popToViewController:preview animated:true];
    
}

@end
