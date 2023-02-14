//
//  OAuthTokenTests.swift
//  AORequestTests
//
//  Created by openfleet on 13/02/2023.
//

import XCTest
@testable import AORequest

final class OAuthTokenTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testisTokenValid_True() throws {
        // Given
        let token = OAuthToken(accessToken: "testAccessToken", tokenType: "myType", refreshToken: "myRefreshToken", expiresIn: 10)
        
        //When
        let result = token.isTokenValid()
        
        // Then
        XCTAssertTrue(result)
    }
    
    func testisTokenValid_False() throws {
        // Given
        let token = OAuthToken(accessToken: "testAccessToken", tokenType: "myType", refreshToken: "myRefreshToken", expiresIn: 0)
        
        //When
        let result = token.isTokenValid()
        
        // Then
        XCTAssertFalse(result)
    }
}
