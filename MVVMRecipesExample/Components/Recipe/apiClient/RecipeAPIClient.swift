//
//  TODOApiClient.swift
//  ProjectTemplate
//
//  Created by Daniel Illescas Romero on 10/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

extension Recipe.Internal {
	final class ApiClient: APIClient {
		
		typealias APIConfigType = Recipe.Internal.Endpoint
		
		static func recipes(fromIngredients ingredients: String, searchQuery: String, page: UInt) -> Future<Models.RecipeResponse> {
			return self.request(.recipes(ingredients: ingredients, searchQuery: searchQuery, page: page))
		}
	}
}
