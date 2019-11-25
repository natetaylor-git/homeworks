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
    var promise: XCTestExpectation!

    override func setUp() {
        super.setUp()
        loadService = PictureLoadService()
    }

    override func tearDown() {
        loadService = nil
        super.tearDown()
    }

    func testThatPictureLoadServiceWorksCorrectly() {
        // arrange
        promise = expectation(description: "Testing image downloading")
        var testData: Data?
        var testError: Error?
        var testResponse: URLResponse?
        // act
        loadService.downloadImage { (data, response, error) in
            testData = data
            testError = error
            testResponse = response
            self.promise.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
        // assert
        XCTAssertNotNil(testResponse)
        XCTAssertTrue(testData != nil || testError != nil)
    }
    
    func testExample() {
    }

    func testPerformanceExample() {
        self.measure {
            
        }
    }

}

//class PresenterStub: PictureInteractorOutputProtocol {
//    func setImage(with imageData: Data) {
//        return
//    }
//
//    func setError(with error: Error) {
//        return
//    }
//
//    
//}
