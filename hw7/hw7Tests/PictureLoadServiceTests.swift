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
    var cacheMock: URLCacheMock!
    var promise: XCTestExpectation!

    override func setUp() {
        super.setUp()
        
        sessionMock = URLSessionMock()
        cacheMock = URLCacheMock()
        loadService = PictureLoadService(session: sessionMock, cache: cacheMock)
    }

    override func tearDown() {
        loadService = nil
        super.tearDown()
    }

    func testThatDownloadDataReturnsData() {
        // arrange
        promise = expectation(description: "Testing image downloading")
        var testData: Data?
        let sessionData = Data(base64Encoded: "testData")
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
    
    func testThatDownloadDataReturnsUrlError() {
        // arrange
        promise = expectation(description: "Testing image downloading")
        var testError: CustomError?
        loadService.urlSource = ""
        let expectedError = CustomError.noUrl
        
        // act
        loadService.downloadImage { (data, response, error) in
            testError = error
            self.promise.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        
        // assert
        XCTAssertNotNil(testError)
        XCTAssertEqual(testError?.errorDescription, expectedError.errorDescription)
    }
    
    func testThatDownloadDataReturnsNoDataError() {
        // arrange
        promise = expectation(description: "Testing image downloading")
        var testError: CustomError?
        let expectedError = CustomError.noData(loadService.urlSource)
        
        // act
        loadService.downloadImage { (data, response, error) in
            testError = error
            self.promise.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        
        // assert
        XCTAssertNotNil(testError)
        XCTAssertEqual(testError?.errorDescription, expectedError.errorDescription)
    }
    
    func testThatDownloadDataReturnsSessionTaskError() {
        // arrange
        promise = expectation(description: "Testing image downloading")
        var testError: CustomError?
        let sessionError = NSError(domain: "sessionError", code: 0, userInfo: nil)
        sessionMock.error = sessionError
        let expectedError = CustomError.sessionError(sessionError)
        
        // act
        loadService.downloadImage { (data, response, error) in
            testError = error
            self.promise.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        
        // assert
        XCTAssertNotNil(testError)
        XCTAssertEqual(testError?.errorDescription, expectedError.errorDescription)
    }
    
    func testThatDownloadImageFromCacheReturnsData() {
        // arrange
        promise = expectation(description: "Testing image downloading from cache")
        var testData: Data?
        
        let cachedData = Data(base64Encoded: "testCacheData") ?? {
            let obj = Data()
            return obj
        }()
        cacheMock.setDataForResponse(data: cachedData)
        
        // act
        loadService.downloadImageFromCache { (data, error) in
            testData = data
            self.promise.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        
        // assert
        XCTAssertEqual(testData, cachedData)
    }
    
    func testThatDownloadImageFromCacheReturnsUrlError() {
        // arrange
        promise = expectation(description: "Testing image downloading from cache")
        var testError: CustomError?
        loadService.urlSource = ""
        let expectedError = CustomError.noUrl
        
        // act
        loadService.downloadImageFromCache { (data, error) in
            testError = error
            self.promise.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        
        // assert
        XCTAssertNotNil(testError)
        XCTAssertEqual(testError?.errorDescription, expectedError.errorDescription)
    }
    
    func testThatDownloadImageFromCacheReturnsEmptyCacheError() {
        // arrange
        promise = expectation(description: "Testing image downloading")
        var testError: CustomError?
        let expectedError = CustomError.emptyCache
        cacheMock.setResponseToNil()
        
        // act
        loadService.downloadImageFromCache { (data, error) in
            testError = error
            self.promise.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        
        // assert
        XCTAssertNotNil(testError)
        XCTAssertEqual(testError?.errorDescription, expectedError.errorDescription)
    }
}

class URLCacheMock: URLCache {
    private var cachedResponse: CachedURLResponse?
    
    func setDataForResponse(data: Data) {
        self.cachedResponse = CachedURLResponse(response: URLResponse(), data: data)
    }
    
    func setResponseToNil() {
        self.cachedResponse = nil
    }
    
    override func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        let cachedURLResponse = cachedResponse
        return cachedURLResponse
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
