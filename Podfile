
source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

xcodeproj 'LJComponentDemo.xcodeproj'

platform :ios, '8.0'

def myPods

#---------三方平台的SDK-----------#

#---------网络相关-----------#

pod 'AFNetworking', '~> 3.1.0'

#---------UI相关-----------#

# Toast
pod 'MBProgressHUD', '0.9'
# 颜色扩展
pod 'Colours', '5.13.0'
# 相对布局
pod 'Masonry', '1.0.1'
# 下拉刷新
pod 'MJRefresh', '~> 3.1.15.1'
# 图片加载
pod 'SDWebImage', '~> 4.0.0'
# 动画
pod 'pop', '~> 1.0'

#---------模型、存储-----------#

# 模型
pod 'MJExtension'
# 缓存&持久
pod 'YYCache', '1.0.3'

#---------杂项-----------#

# 基础扩展
pod 'YYCategories', '1.0.3'

#---------调试-----------#

# 日志
pod 'CocoaLumberjack', '2.3.0'
# 工具
pod 'FLEX', '2.3.0', :configurations => ['Debug']
pod 'JPFPSStatus', '~> 0.1'

end

target 'LJComponentDemo' do
    myPods
end

target 'LJComponentDemoTests' do
    myPods
end

