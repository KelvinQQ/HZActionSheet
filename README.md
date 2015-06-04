HZActionSheet
===========

模仿微信的ActionSheet.支持修改文字颜色,支持多行.

###效果图


![image](https://github.com/HistoryZhang/HZActionSheet/blob/master/screenshot.gif)


###使用方法

* 使用`cocoapods`
	1. 在`Podfile`中添加`pod 'HZActionSheet'`.
	2. 运行`pod update`.
	3. 由于我使用了第三方库[`Masonry`](https://github.com/cloudkite/Masonry),所以最终下载的源码也包括`Masonry`.关于`Masonry`,大家可自行`google`.

* 不使用`cocoapods`
	1. 下载代码之后,添加文件夹`HZActionSheet`.
	2. 你还需要下载另一个三方库[`Masonry`](https://github.com/cloudkite/Masonry).
	
* 添加代码

	创建`HZActionSheet`
	
	```
	HZActionSheet *sheet = [[HZActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonIndexSet:nil otherButtonTitles:@[@"相册", @"相机"]];
    ```
    
    `destructiveButton`传递的是一个`IndexSet`.
    
    显示`HZActionSheet`
    
    ```
    [sheet showInView:self.view];
    ```
    `HZActionSheet`是添加到`view`的`window`上的,所以不需要传递`view.window`属性.
    
    点击按钮在`delegate`中处理
    
    ```
    - (void)actionSheet:(HZActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
	{
    	if (actionSheet.cancelButtonIndex != buttonIndex) {
        	NSLog(@"你点击了 %@", @(buttonIndex));
    	}
	}
    ```
    
    给按钮设置其他颜色
    
    ```
    sheet.titleColor = [UIColor purpleColor];
    ```