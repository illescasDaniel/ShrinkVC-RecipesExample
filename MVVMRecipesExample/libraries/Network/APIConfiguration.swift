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
}

public protocol APIConfiguration: URLRequestConvertible {
	var baseURL: URLConvertible { get }
	var path: String { get }
	var method: HTTPMethod { get }
	var parameters: Parameters? { get }
}

public extension APIConfiguration {
	public func asURLRequest() throws -> URLRequest {
		
		let url = try self.baseURL.asURL()
		
		var urlRequest = URLRequest(url: url.appendingPathComponent(self.path))
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
