BDFoundation
============

日常用到的iOS组件封装

使用方法：
    添加submodule：
        1, git submodule add https://github.com/liuwanwei/BDFoundation.git libs/BDFoundation
        2, git submodule add  https://github.com/liuwanwei/MJRefresh.git libs/MJRefresh
            注意：添加到项目时，只添加MJRefresh子目录
    添加pod：
        1, pod init
        2, 修改Podfile，搜索YSASIHTTPRequest，安装这个时候，因为依赖关系，会自动安装下面的：
            KxMenu
            MBProgressHUD
            Reachability
            SDWebImage
        3, pod install --no-repo-update
