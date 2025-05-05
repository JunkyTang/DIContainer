import XCTest
import DIContainer

class Tests: XCTestCase {
    
    @MainActor
    override func setUp() {
        super.setUp()
        DIContainer.shared.removeAll()
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
    
    // MARK: - Inject Property Wrapper Tests

    @MainActor
    func testInjectDependencySuccessfully() {
        // 正向测试
        try? DIContainer.shared.register(interface: ModuleTypeA.self, impl: ModuleA())
        let something = Something()
        
        XCTAssertNotNil(something.moduleA)
        XCTAssertEqual(something.moduleA?.name, "Module A")
    }

    @MainActor
    func testInjectDependencyThrowsErrorWhenNotRegistered() {
        // 反向测试
        let something = Something()
        XCTAssertNil(something.moduleA)
    }

    @MainActor
    func testInjectCacheDependencySuccessfully() {
        // 正向测试
        try? DIContainer.shared.register(interface: ModuleTypeA.self, impl: ModuleA())
        let something = Something()
        _ = something.cacheModuleA
        DIContainer.shared.removeAll()
        XCTAssertNotNil(something.cacheModuleA)
        XCTAssertEqual(something.cacheModuleA?.name, "Module A")
    }
    
    @MainActor
    func testInjectCacheDependencyFailsWhenNotRegistered() {
        // 反向测试
        let something = Something()
        XCTAssertNil(something.cacheModuleA)
    }

    @MainActor
    func testInjectDefault_UseResolvedInstance() {
        // 注册 ModuleA 到 DIContainer
        try? DIContainer.shared.register(interface: ModuleTypeA.self, impl: ModuleA())
        let something = Something()

        // 因为 InjectDefault 会优先 resolve，所以应返回 ModuleA 而不是默认的 ModuleA2
        XCTAssertEqual(something.defaultModuleA.name, "Module A")
    }
    
    @MainActor
    func testInjectDefault_UseDefaultFallback() {
        // 确保未注册 ModuleTypeA
        DIContainer.shared.removeAll()
        let something = Something()

        // 因为容器中没有注册，应该使用默认值 ModuleA2
        XCTAssertEqual(something.defaultModuleA.name, "Module A2")
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


class Something {
    
    @Inject
    var moduleA: ModuleTypeA?
    
    @Inject(cache: true)
    var cacheModuleA: ModuleTypeA?
    
    @InjectDefault(defoult: ModuleA2())
    var defaultModuleA: ModuleTypeA
    
}


