//
//  RequestManager.swift
//  AORequest
//
//  Created by openfleet on 11/02/2023.
//

import Foundation
import OSLog

class RequestManager {
    // MARK: properties
    let logger: Logger
    let session: URLSession
    let decoder: JSONDecoder
    let isDebug = true
    
    // MARK: init
    init(logger: Logger, session: URLSession, decoder: JSONDecoder) {
        self.logger = logger
        self.session = session
        self.decoder = decoder
    }
    
    // MARK: - Method
    
    // MARK: generic
    func doRequest<R>(from request: URLRequest, type: R.Type, statusCodes: [Int]) async throws -> R where R : Decodable {
        guard let (data, response) = try? await session.data(for: request)
        else {
            logger.debug("Failed to retrieve data.")
            throw AORequestError.missingData
        }
        defer {
            if isDebug,
               let utf8Result = String(data: data, encoding: String.Encoding.utf8) {
                logger.debug("utf8Result \(utf8Result) ")
            }
        }
        
        // Manage HTTPURL conversion
        guard let httpResponse = response as? HTTPURLResponse
        else {
            logger.debug("Failed to received valid HTTPURLResponse.")
            throw AORequestError.missingData
        }
        
        // Manage status code response
        guard  statusCodes.reduce(false, { partialResult, statusCode in
            partialResult || httpResponse.statusCode == statusCode
        })
        else {
            logger.debug("Failed to received valid statusCode: \(httpResponse.statusCode)")
            throw AORequestError.invalidStatusCode(statusCode: httpResponse.statusCode)
        }
        
        
        // Decode the JSON into a data model.
        return try decoder.decode(R.self, from: data)
    }
    
    // MARK: GET
    func getRequest<R>(from url: URL, type: R.Type, statusCode: [Int] = [200]) async throws -> R where R : Decodable {
        // Manage request result
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return try await doRequest(from: request, type: type, statusCodes: statusCode)
        
    }
    
    // MARK: POST
    func postRequest<R: Decodable>(from url: URL, type: R.Type, parameters: [String:Any], httpHeaderFields: [String: String] = [String:String](), statusCode: [Int] = [200]) async throws -> R {
        // Manage request result
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        httpHeaderFields.forEach { (key: String, value: String) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        var urlParser = URLComponents()
        urlParser.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        guard let httpBodyString = urlParser.percentEncodedQuery,
              let httpBodyData = httpBodyString.data(using: String.Encoding.utf8) else {
            throw AORequestError.wrongBodyDataFormat
        }
        request.httpBody = httpBodyData
        return try await doRequest(from: request, type: type, statusCodes: statusCode)
    }
    
}
