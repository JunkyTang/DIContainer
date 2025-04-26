import XCTest
import DIContainer

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    @MainActor
    func testResolveRegisteredModuleReturnsCorrectInstance() {
        // 正向测试：验证注册后可以成功解析
        try? DIContainer.shared.register(interface: ModuleTypeA.self, impl: ModuleA())
        XCTAssertNoThrow(try {
            let instanceA = try DIContainer.shared.resolve(interface: ModuleTypeA.self)
            XCTAssertEqual(instanceA.name, "Module A")
        }())
    }
    
    @MainActor
    func testResolveUnregisteredModuleThrowsError() {
        // 反向测试：未注册类型解析时应抛出异常
        XCTAssertThrowsError(try DIContainer.shared.resolve(interface: ModuleTypeB.self)) { error in
            XCTAssertEqual(error as! Exception, Exception.moduleNotFound)
        }
    }
    
    @MainActor
    func testDuplicateRegistrationThrowsError() {
        // 正向测试：测试重复注册抛出异常
        try? DIContainer.shared.register(interface: ModuleTypeA.self, impl: ModuleA())
        XCTAssertThrowsError(try DIContainer.shared.register(interface: ModuleTypeA.self, impl: ModuleA2())) { error in
            XCTAssertEqual(error as! Exception, Exception.duplicateRegistration)
        }
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}


protocol ModuleTypeA {
    var name: String { get }
}

class ModuleA: ModuleTypeA {
    var name: String { "Module A" }
}

class ModuleA2: ModuleTypeA {
    var name: String { "Module A2" }
}


protocol ModuleTypeB {}
