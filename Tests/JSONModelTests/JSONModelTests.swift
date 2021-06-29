import XCTest
@testable import JSONModel

final class JSONModelTests: XCTestCase {
    /// 测试结构体
    func testStruct() {
        let model = try! Model(from: jsonString)
        print(model)
        
        XCTAssertTrue(
            model.message == "success" &&
                model.status == 200 &&
                model.content.avatar == "" &&
                model.content.nickName == "用户l2y0H3s00s" &&
                model.content.uid == 100009
        )
        
        XCTAssertTrue((try? model.asJSONString()?.sorted()) == jsonString.sorted())
    }
    
    /// 测试类
    func testClass() {
        let model = try! ModelClass(from: jsonString)

        print(model)
        
        XCTAssertTrue(
            model.message == "success" &&
                model.status == 200 &&
                model.content.avatar == "" &&
                model.content.nickName == "用户l2y0H3s00s" &&
                model.content.uid == 100009
        )
        XCTAssertTrue((try? model.asJSONString()?.sorted()) == jsonString.sorted())
    }
    
    /// 测试继承类
    func testClassInherit() {
        let model = try! ModelInheritClass(from: jsonString)
        print(model)
        
        XCTAssertTrue(
            model.message == "success" &&
                model.status == 200 &&
                model.content.avatar == "" &&
                model.content.nickName == "用户l2y0H3s00s" &&
                model.content.uid == "100009"
        )
        XCTAssertTrue((try? model.asJSONString()?.sorted()) == jsonString.sorted())
    }
}


class ModelInheritClass: ModelBaseClass {
    @JSON("status") var status: Int
    var haha: String = "hah"
}

class ContentClass: JSONModel {
    @JSON("avatar") var avatar: String
    @JSON("nickname") var nickName: String
    @JSON("uid") var uid: String?
    @JSON("emmm") var lala: Int?

    required init() {}
}

class ModelBaseClass: JSONModel {
    @JSON("msg") var message: String
    @JSON("data") var content: ContentClass
    required init() {}
}






class ModelClass: JSONModel {
    class ContentClass: JSONModel {
        @JSON("avatar") var avatar: String
        @JSON("nickname") var nickName: String
        @JSON("uid") var uid: Int
        
        required init() {}
    }
    
    @JSON("msg") var message: String
    @JSON("status") var status: Int
    @JSON("data") var content: ContentClass
    required init() {}
}



struct Model: JSONModel {
    struct Content: JSONModel {
        @JSON("avatar")
        var avatar: String
        
        @JSON("nickname")
        var nickName: String
        
        @JSON("uid")
        var uid: Int
    }
    
    @JSON("msg") var message: String
    @JSON("status") var status: Int
    @JSON("data") var content: Content
}

let jsonString = "{\"msg\":\"success\",\"status\":200,\"data\":{\"avatar\":\"\",\"nickname\":\"用户l2y0H3s00s\",\"uid\":100009}}"
