//
//  AORequestError.swift
//  AORequest
//
//  Created by openfleet on 11/02/2023.
//

import Foundation

enum AORequestError: Error {
    case wrongDataFormat(error: Error)
    case wrongBodyDataFormat
    case missingData
    case invalidStatusCode(statusCode: Int)
    case wrongURLFormat(urlString: String)
    case unexpectedError(error: Error)
}
