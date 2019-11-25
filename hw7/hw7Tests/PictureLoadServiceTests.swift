//
//  PictureInteractorTests.swift
//  hw7Tests
//
//  Created by nate.taylor_macbook on 25/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import XCTest
@testable import hw7

class PictureLoadServiceTests: XCTestCase {
    var loadService: PictureLoadServiceProtocol!
    var sessionMock: URLSessionMock!
    var promise: XCTestExpectation!

    override func setUp() {
        super.setUp()
        
        sessionMock = URLSessionMock()
        loadService = PictureLoadService(session: sessionMock)
    }

    override func tearDown() {
        loadService = nil
        super.tearDown()
    }

    func testThatPictureLoadServiceReturnsData() {
        // arrange
        promise = expectation(description: "Testing image downloading")
        var testData: Data?
        let sessionData = Data(base64Encoded: "test")
        sessionMock.data = sessionData
        
        // act
        loadService.downloadImage { (data, response, error) in
            testData = data
            self.promise.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        
        // assert
        XCTAssertEqual(testData, sessionData)
    }
    
    func testExample() {
    }

    func testPerformanceExample() {
        self.measure {
            
        }
    }

}

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        self.closure()
    }
}

class URLSessionMock: URLSession {
    var data: Data?
    var error: Error?
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        
        return URLSessionDataTaskMock {
            completionHandler(data, nil, error)
        }
    }
}
