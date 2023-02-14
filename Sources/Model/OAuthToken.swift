//
//  OAuthToken.swift
//  AORequest
//
//  Created by openfleet on 11/02/2023.
//

import Foundation

struct OAuthToken: Decodable {
    // MARK: Properties
    let accessDate: Date = Date()
    let accessToken: String
    let tokenType: String
    let refreshToken: String
    let expiresIn: Int
    
    // MARK: Decodable
    private enum CodingKeys: CodingKey {
        case accessToken
        case tokenType
        case refreshToken
        case expiresIn
    }
    
    func isTokenValid() -> Bool {
        return Date() < Date(timeIntervalSince1970: accessDate.timeIntervalSince1970 + Double(expiresIn))
    }
}
/*{
  "access_token": "fe47d528-7414-4962-a7e6-ee6b82491f7a",
  "token_type": "Bearer"
  "refresh_token": "9b465388-c9e2-45d3-98d0-1a44a503ec40",
  "expires_in": 43199,
  }*/

