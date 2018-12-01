# AGBadgeManager
### 思路描述
- 1，同一个消息通知的红点数，可能需要在不同页面进行更新维护，所以采用了观察者的模式设计。
- 2，为了方便对不同消息进行区分和管理，所以把每个消息独立封装成类。
- 3，消息类派生自AGBadgeManager，作为子类使用父类的方法就足够了，不需要实现任何方法。使用派生类是为了方便对各个消息进行维护和管理，简化使用过程。
- 4，对于存储方式，可能有不同的需求，所以用协议的方法交给用户自定义。

### cocoapods 集成
```
platform :ios, '7.0'
target 'AGBadgeManagerDemo' do

pod 'AGBadgeManager'

end
```

### 使用说明
```objective-c
/** 
用户可以根据<AGBadgePersistentDelegate>协议，自定义存储方式。
 1，默认使用的存储方式是 NSUserDefaults。
 2，遵守<AGBadgePersistentDelegate>协议的对象就能注入到 AGBadgeManager 作为内部存储对象。
 [AGBadgeManager ag_configurationPersistent:(id<AGBadgePersistentDelegate>)persistent];
       
创建各个消息类
 1，不同的消息类继承自 AGBadgeManager，所以拥有父类的所有方法。
 2，派生类几乎不需要实现任何方法。
 
具体可参考 Demo
 */

// 1. 配置与保存
// 1.1 在 App启动时可以配置个性存储器
[AGBadgeManager ag_configurationPersistent:(id<AGBadgePersistentDelegate>)persistent];

// 1.2 在 App退出时保存数据
[AGBadgeManager ag_persistentAll];


// 2. 添加要监听消息变化的观察者
// 2.1 Add observer
[self.ticketBadgeManager ag_registerObserver:self];

// 2.2 实现代理方法，进行界面更新等操作
- (void)badgeManagerDidChange:(NSInteger)changeBadge
                      current:(NSString *)currentBadge
                         mode:(AGBadgeManagerChangeMode)mode
                      forType:(NSString *)type
{
    if ( [self.ticketBadgeManager ag_isEqualToType:type] ) {
        
        if ( currentBadge.integerValue > 0 ) {
            self.ticketVC.tabBarItem.badgeValue = currentBadge;
        }
        else {
            self.ticketVC.tabBarItem.badgeValue = nil;
        }
    }
}

// 3. 消息数目维护
// 3.1 使用 AGBadgeManager 的 ag_minus、ag_plus 等方法对消息数据进行修改维护
[self.ticketBadgeManager ag_plus];
[self.ticketBadgeManager ag_minus];

```

