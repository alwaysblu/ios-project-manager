//
//  ProjectManagerTests.swift
//  ProjectManagerTests
//
//  Created by 최정민 on 2021/08/04.
//

import XCTest

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    // We override the 'resume' method and simply call our closure
    // instead of actually resuming any task.
    override func resume() {
        closure()
    }
}


final class URLSessionStub: URLSessionProtocol {
    var requestParameters: (
        url: URL,
        completionHandler: (Data?, URLResponse?, Error?) -> Void
    )?
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.requestParameters = (
            url: url,
            completionHandler: completionHandler
        )
    }
}

@testable import ProjectManager
class ProjectManagerTests: XCTestCase {
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_get_성공() { // 네트워크 의존적인 테스트
        
        // given
        var sessionManagerStub = SessionManagerStub()
        let service = NetworkManager(sessionManager: sessionManagerStub)
        
        // when
        service.search()
        
        // then
        
        
        networkManager.get { tasks in
            XCTAssertEqual(tasks!,nil)
        }
        
    }

}
