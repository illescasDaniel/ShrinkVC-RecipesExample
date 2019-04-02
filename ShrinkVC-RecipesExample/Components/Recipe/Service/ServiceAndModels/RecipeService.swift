//
//  TODOService.swift
//  ProjectTemplate
//
//  Created by Daniel Illescas Romero on 10/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

protocol RecipeServiceProtocol {
	static func recipesFrom(ingredients: String, searchQuery: String, page: UInt) -> Future<[Recipe.Service.Models.RecipeModel]>
}

extension Recipe {
	final class Service: APIService, RecipeServiceProtocol {
		
		typealias Client = Recipe.Internal.ApiClient
		
		static func recipesFrom(ingredients: String = "", searchQuery: String = "", page: UInt = 1) -> Future<[Models.RecipeModel]> {
			return Client.recipes(fromIngredients: ingredients, searchQuery: searchQuery, page: page)
				.map(Models.RecipeModel.map)
		}
	}
}
