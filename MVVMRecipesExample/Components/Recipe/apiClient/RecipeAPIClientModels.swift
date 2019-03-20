//
//  TODOResponse.swift
//  ProjectTemplate
//
//  Created by Daniel Illescas Romero on 10/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

extension Recipe.Internal.ApiClient {
	enum Models {
		// For RecipeEndpoint.recipe(_)
		struct RecipeResponse: Decodable {
			let title: String
			let version: Double
			let href: URL
			let results: [Result]
			struct Result: Decodable {
				let title: String
				let href: URL
				let ingredients: String // separated by comma
				let thumbnail: String // empty if no thumbnail available
			}
		}
	}
}
