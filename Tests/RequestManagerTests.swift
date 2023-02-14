//
//  RequestManagerTests.swift
//  AORequestTests
//
//  Created by openfleet on 11/02/2023.
//

import XCTest
import OSLog
@testable import AORequest

struct TestEntity: Decodable {
    let id: Int
    let nodeId: String
    let name: String
    
}


final class RequestManagerTests: XCTestCase {
    let url: String = "https://api.github.com/orgs/apple/repos"

    var requestManager = RequestManager(logger: Logger(subsystem: "com.airone.RequestManagerTests.tests", category: "Framework"), session: URLSession.shared, decoder: JSONDecoder())
    
    override func setUpWithError() throws {
        let logger = Logger(subsystem: "com.airone.RequestManagerTests.tests", category: "Framework")
        let session = URLSession.shared
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        requestManager = RequestManager(logger: logger, session: session, decoder: decoder)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() throws {
        // Given
        let logger = Logger(subsystem: "com.airone.RequestManagerTests.tests", category: "Framework")
        let session = URLSession.shared
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // When
        requestManager = RequestManager(logger: logger, session: session, decoder: decoder)
        
        // Then
        XCTAssertEqual(session, requestManager.session)
    }
    
    func testGetRequestNotJSON() async throws {
        // Given
        let url = URL(string: "https://www.google.com")!
        
        // When
        do {
            let _ = try await requestManager.getRequest(from: url, type: TestEntity.self)
        } catch DecodingError.dataCorrupted(let context) {
            // Then
            print(context)
        } catch {
            XCTFail("Wrong exception")
        }
    }
    
    func testGetRequestJSON() async throws {
        // Given
        let url = URL(string: url)!
        
        // When
        let result = try await requestManager.getRequest(from: url, type: [TestEntity].self)
        
        // Then
        XCTAssertEqual(result.first?.name,  "cups")
    }
    
    func testGetRequestJSON_statusCode_failed() async throws {
        // Given
        let url = URL(string: url)!
        let statusCodes = [400]
        
        // When
        do {
            let _ = try await requestManager.getRequest(from: url, type: [TestEntity].self, statusCode: statusCodes)
            XCTFail("GetRequest should failed")
        } catch AORequestError.invalidStatusCode(let statusCode) {
            // Then
            XCTAssertEqual(statusCode, 200)
        } catch {
            XCTFail("Wrong exception \(error)")
        }
    }
    
}
