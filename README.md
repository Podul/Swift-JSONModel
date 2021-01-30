# JSONModel


## Usage

1. 首先导入模块
``` Swift
import JSONModel
```

2. 新建模型，并遵守 `JSONModel` 协议
``` Swift
struct Model: JSONModel {
    struct Content: JSONModel {
        @JSONField("avatar")
        var avatar: String
        
        @JSONField("nickname")
        var nickName: String
        
        @JSONField("uid")
        var uid: Int
    }
    
    @JSONField("msg") var message: String
    @JSONField("status") var status: Int
    @JSONField("data") var content: Content
}

```
3. 使用
``` Swift
let jsonString = "{\"msg\":\"success\",\"status\":200,\"data\":{\"avatar\":\"\",\"nickname\":\"用户l2y0H3s00s\",\"uid\":100009}}"
let data = jsonString.data(using: .utf8)
let model = try! JSONDecoder().decode(Model.self, from: data!)
```

## Requirements

* iOS 9.0+
* Xcode 10.10+
* Swift 5+

## Installation

### Swift Package Manager
``` Swift
dependencies: [
     .package(name: "JSONModel", url: "https://github.com/Podul/Swift-JSONModel.git", .branch("master"))
]
```
## Author

Podul, ylpodul@gmail.com

## License

JSONModel is available under the MIT license. See the LICENSE file for more info.
