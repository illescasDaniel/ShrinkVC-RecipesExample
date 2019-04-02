//
//  Network+Extension.swift
//  ProjectTemplate
//
//  Created by Daniel Illescas Romero on 10/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation


public protocol URLRequestConvertible {
	func asURLRequest() throws -> URLRequest
}
/*extension URLRequestConvertible {
	
	/// The `URLRequest` returned by discarding any `Error` encountered.
	public var urlRequest: URLRequest? { get }
}*/

//

enum URLConvertibleError: Error {
	case invalidURL
}
public protocol URLConvertible {
	func asURL() throws -> URL
}

extension String: URLConvertible {
	public func asURL() throws -> URL {
		if let url = URL(string: self) {
			return url
		}
		throw URLConvertibleError.invalidURL
	}
}

extension URL: URLConvertible {
	public func asURL() throws -> URL {
		return self
	}
}

//

public enum HTTPMethod: String {
	case connect
	case delete
	case get
	case head
	case options
	case patch
	case post
	case put
	case trace
}

public typealias Parameters = [String : Any]

public enum HTTPHeaderField: String {
	case authentication = "Authorization"
	case contentType = "Content-Type"
	case acceptType = "Accept"
	case acceptEncoding = "Accept-Encoding"
}

public enum ContentType: String {
	case json = "application/json"
}
