//
//  ShopperTests.swift
//  ShopperTests
//
//  Created by Vitor Dinis on 21/10/2022.
//

import XCTest
import Combine
@testable import Shopper

final class ShopperTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testProductFetching() {
        var error: Product.ProductAPIError?
        var productList: [Product] = []
        
        let expectation = expectation(description: "Products Fetched")
        
        Product.loadProductList()
            .sink { result in
                switch result {
                case .failure(let resultError):
                    print("ERROR: \(resultError.localizedDescription)")
                    error = resultError
                case .finished:
                    break
                }
                expectation.fulfill()
            } receiveValue: { value in
                productList = value
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNil(error)
        XCTAssert(!productList.isEmpty)
    }
    
    func testProductFetchingWithCategory() {
        var error: Product.ProductAPIError?
        var productList: [Product] = []
        
        let expectation = expectation(description: "Products Fetched")
        
        Product.loadProductList(category: "smartphones")
            .sink { result in
                switch result {
                case .failure(let resultError):
                    print("ERROR: \(resultError.localizedDescription)")
                    error = resultError
                case .finished:
                    break
                }
                expectation.fulfill()
            } receiveValue: { value in
                productList = value
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNil(error)
        XCTAssert(!productList.isEmpty)
    }
    
    func testProductFetchingWithWrongCategory() {
        var error: Product.ProductAPIError?
        var productList: [Product] = []
        
        let expectation = expectation(description: "Products Fetched")
        
        Product.loadProductList(category: "823ruf?*")
            .sink { result in
                switch result {
                case .failure(let resultError):
                    print("ERROR: \(resultError.localizedDescription)")
                    error = resultError
                case .finished:
                    break
                }
                expectation.fulfill()
            } receiveValue: { value in
                productList = value
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNil(error)
        XCTAssert(productList.isEmpty)
    }
}
