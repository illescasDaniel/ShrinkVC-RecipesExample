//
//  TODOService.swift
//  ProjectTemplate
//
//  Created by Daniel Illescas Romero on 10/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

extension Recipe {
	final class Service: APIService {
		
		typealias Client = Recipe.Internal.ApiClient
		
		static func recipesFrom(ingredients: String = "", searchQuery: String = "", page: UInt = 1) -> Future<[ViewModels.RecipeViewModel]> {
			return Models.RecipeModel.from(Client.recipes(fromIngredients: ingredients, searchQuery: searchQuery, page: page))
				.map(ViewModels.RecipeViewModel.map)
		}
	}
}
