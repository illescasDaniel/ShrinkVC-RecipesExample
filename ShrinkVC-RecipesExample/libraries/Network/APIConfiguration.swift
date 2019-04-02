//
//  APIConfiguration.swift
//  ProjectTemplate
//
//  Created by Daniel Illescas Romero on 10/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

enum APIConfigurationError: Error {
	case invalidBody
	case invalidURLComponents
}

public protocol APIConfiguration: URLRequestConvertible {
	var baseURL: URLConvertible { get }
	var path: String { get }
	var queryItems: [URLQueryItem] { get }
	var method: HTTPMethod { get }
	var parameters: Parameters? { get }
}

public extension APIConfiguration {
	func asURLRequest() throws -> URLRequest {
		
		let baseURL = try self.baseURL.asURL()
		
		let baseURLWithPath = baseURL.appendingPathComponent(self.path)
		var urlComponents = URLComponents(url: baseURLWithPath, resolvingAgainstBaseURL: true)
		urlComponents?.queryItems = self.queryItems
		
		guard let fullURL = urlComponents?.url?.absoluteURL else { throw APIConfigurationError.invalidURLComponents }
		
		var urlRequest = URLRequest(url: fullURL)
		urlRequest.timeoutInterval = 20
		urlRequest.httpMethod = self.method.rawValue.uppercased()
		urlRequest.setValue(ContentType.json.rawValue,
							forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
		urlRequest.setValue(ContentType.json.rawValue,
							forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
		
		if let parameters = parameters {
			do {
				urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
			} catch {
				throw APIConfigurationError.invalidBody
			}
		}
		
		return urlRequest
	}
}
