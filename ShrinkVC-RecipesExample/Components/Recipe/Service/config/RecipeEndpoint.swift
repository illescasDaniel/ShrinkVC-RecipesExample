//
//  TODOEndpoint.swift
//  ProjectTemplate
//
//  Created by Daniel Illescas Romero on 10/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

extension Recipe.Internal {
	enum Endpoint: APIConfiguration {
		
		case recipes(ingredients: String, searchQuery: String, page: UInt)
		
		// MARK: -
		
		var baseURL: URLConvertible {
			return "http://www.recipepuppy.com"
		}
		
		var path: String {
			switch self {
			case .recipes:
				return "api/"
			}
		}
		
		var queryItems: [URLQueryItem] {
			switch self {
				case .recipes(let ingredients, let searchQuery, let page):
					return [
						URLQueryItem(name: "i", value: ingredients),
						URLQueryItem(name: "q", value: searchQuery),
						URLQueryItem(name: "p", value: "\(page)")
					]
			}
		}
		
		var method: HTTPMethod {
			switch self {
			case .recipes: return .get
			}
		}
		
		// post parameters (httpBody)
		var parameters: Parameters? {
			switch self {
			case .recipes: return nil
			}
		}
	}
}
