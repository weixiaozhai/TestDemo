//
//  TestDemoTests.swift
//  TestDemoTests
//
//  Created by 潘佳炜 on 2022/8/19.
//

import XCTest
@testable import TestDemo

class TestDemoTests: XCTestCase {

    // 在每一个测试方法调用前，都会被调用
    // 用来初始化 test 用例的一些初始值
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    // 在每一个测试方法调用后，都会被调用
    // 用来重置 test 方法的数值
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    //测试用例
    //所有测试的方法都需要以test为前缀进行命名
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    // 性能测试
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
