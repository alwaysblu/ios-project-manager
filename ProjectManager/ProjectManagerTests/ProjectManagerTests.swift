//
//  ProjectManagerTests.swift
//  ProjectManagerTests
//
//  Created by 최정민 on 2021/08/04.
//

import XCTest




@testable import ProjectManager
class ProjectManagerTests: XCTestCase {
    
    var networkLoader: NetworkLoader!
    var expectation: XCTestExpectation!
    let apiURL = URL(string: Secret.baseURL)!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self] // 프로토콜 클래스의 배열
        let urlSession = URLSession.init(configuration: configuration)
        networkLoader = NetworkLoader(session: urlSession)
    }
    
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
    
    func test_get_성공() throws { // Setup our objects
        // Prepare mock response.
         // 📌 1 단계 : mock JSON 데이터를 준비한다.
        let taskTitle = "titleTest"
        let taskDetail = "detailTest"
        let taskDeadline: Double = 0
        let taskStatus = "statusTest"
        let taskId = "idTest"
        let tasks = [Task(title: taskTitle, detail: taskDetail, deadline: taskDeadline, status: taskStatus, id: taskId)]
        let data = try? JSONEncoder().encode(tasks)
        expectation = expectation(description: "Expectation")
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == self.apiURL else {
                // 헤더, HTTP 메서드 같은 component들도 확인할 수 있다.
                throw DataError.invalidURL
            }
            
            let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        // Call API.
        networkLoader.loadData(with: apiURL) { result in
            switch result {
            case .success(let taskData):
                let task = try? JSONDecoder().decode([Task].self, from: taskData)
                print("@@@@",task?[0].title)
                XCTAssertEqual(taskData, data, "Incorrect data.")
            case .failure(let error):
                XCTFail("Error was not expected: \(error)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

class MockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        // To check if this protocol can handle the given request.
        // 이 프로토콜이 주어진 request를 다룰 수 있는지 체크하기 위한 함수이다.
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        // Here you return the canonical version of the request but most of the time you pass the orignal one.
        // 여기에서는 request의 표준 버전을 반환하지만 대부분의 경우 오리지날 버전을 전달한다.
        return request
    }
    
    override func startLoading() {
        // This is where you create the mock response as per your test case and send it to the URLProtocolClient.
        // 여기에서 테스트 케이스에 따라 mock response를 만들고 URLProtocolClient로 보낸다.
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }
        
        do {
            // 2. Call handler with received request and capture the tuple of response and data.
            // 📌 2 단계 : 수신된 request로 requestHandler 클로저를 호출하고 (reponse, data)를 캡쳐한다.
            let (response, data) = try handler(request) //request가 뭐임? URLProtocol로부터 상속된 프로퍼티임
            
            // 3. Send received response to the client.
            // 📌 3 단계 : 클라이언트에게 수신 받은 response를 보낸다.
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if let data = data {
                // 4. Send received data to the client.
                // 📌 4 단계 : 수신 받은 데이터를 클라이언트에게 보낸다.
                client?.urlProtocol(self, didLoad: data)
            }
            
            // 5. Notify request has been finished.
            // 📌 5 단계 : request가 완료되었다고 알린다.
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            // 6. Notify received error.
            // 📌 2 단계 : 수신 받은 에러를 알린다.
            client?.urlProtocol(self, didFailWithError: error)
        }
        
    }
    
    override func stopLoading() {
        // This is called if the request gets canceled or completed.
        // request가 취소되거나 완료되면 호출된다.
    }
}
