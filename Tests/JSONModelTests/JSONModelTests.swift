import XCTest
@testable import JSONModel

final class JSONModelTests: XCTestCase {
    /// 测试结构体
    func testStruct() {
        let data = jsonString.data(using: .utf8)
        let model = try! JSONDecoder().decode(Model.self, from: data!)
        print(model)
        
        XCTAssertTrue(
            model.message == "success" &&
                model.status == 200 &&
                model.content.avatar == "" &&
                model.content.nickName == "用户l2y0H3s00s" &&
                model.content.uid == 100009
        )
        
        XCTAssertTrue((try! JSONEncoder().encode(model)).count == data?.count)
    }
    
    /// 测试类
    func testClass() {
        let data = jsonString.data(using: .utf8)
        let model = try! JSONDecoder().decode(ModelClass.self, from: data!)
        print(model)
        
        XCTAssertTrue(
            model.message == "success" &&
                model.status == 200 &&
                model.content.avatar == "" &&
                model.content.nickName == "用户l2y0H3s00s" &&
                model.content.uid == 100009
        )
        
        XCTAssertTrue((try! JSONEncoder().encode(model)).count == data?.count)
    }
    
    /// 测试继承类
    func testClassInherit() {
        let data = jsonString.data(using: .utf8)
        let model = try! JSONDecoder().decode(ModelInheritClass.self, from: data!)
        print(model)
        
        XCTAssertTrue(
            model.message == "success" &&
                model.status == 200 &&
                model.content.avatar == "" &&
                model.content.nickName == "用户l2y0H3s00s" &&
                model.content.uid == "100009"
        )
        
        print(model.content.lala)
    }
    
    
}


class ModelInheritClass: ModelBaseClass {
    @JSONField("status") var status: Int
    var haha: String = "hah"
}

class ContentClass: JSONModel {
    @JSONField("avatar") var avatar: String
    @JSONField("nickname") var nickName: String
    @JSONField("uid") var uid: String?
    @JSONField("emmm") var lala: Int?

    required init() {}
}

class ModelBaseClass: JSONModel {
    @JSONField("msg") var message: String
    @JSONField("data") var content: ContentClass
    required init() {}
}






class ModelClass: JSONModel {
    class ContentClass: JSONModel {
        @JSONField("avatar") var avatar: String
        @JSONField("nickname") var nickName: String
        @JSONField("uid") var uid: Int
        
        required init() {}
    }
    
    @JSONField("msg") var message: String
    @JSONField("status") var status: Int
    @JSONField("data") var content: ContentClass
    required init() {}
}



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

let jsonString = "{\"msg\":\"success\",\"status\":200,\"data\":{\"avatar\":\"\",\"nickname\":\"用户l2y0H3s00s\",\"uid\":100009}}"
