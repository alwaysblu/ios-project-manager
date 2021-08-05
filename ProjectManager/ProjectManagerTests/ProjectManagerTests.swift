//
//  ProjectManagerTests.swift
//  ProjectManagerTests
//
//  Created by 최정민 on 2021/08/04.
//

import XCTest

// We create a partial mock by subclassing the original class
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

class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

    // Properties that enable us to set exactly what data or error
    // we want our mocked URLSession to return for any request.
    var data: Data?
    var error: Error?

    override func dataTask(
        with url: URL,
        completionHandler: @escaping CompletionHandler
    ) -> URLSessionDataTask {
        let data = self.data
        let error = self.error

        return URLSessionDataTaskMock {
            completionHandler(data, HTTPURLResponse(), error)
        }
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
    
    func test_get_성공() { // Setup our objects
        let session = URLSessionMock()
        let manager = NetworkManager(session: session)

        // Create data and tell the session to always return it
        
        let tasks = [Task(title: "test", detail: "test", deadline: 0, status: "test", id: "test")]
        let data = try? JSONEncoder().encode(tasks)
        session.data = data

        // Perform the request and verify the result
        var result: [Task]?
        manager.get{ result = $0 }
        let resultData = try? JSONEncoder().encode(result)
        XCTAssertEqual(resultData, data)
    }

}
