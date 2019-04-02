//
//  RecipeUseCase.swift
//  MVVMRecipesExample
//
//  Created by Daniel Illescas Romero on 01/04/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

protocol RecipeUseCaseProtocol: UseCase where
ReturnElement == (recipes: [Recipe.UseCase.ViewModels.RecipeViewModel], page: UInt) {}

extension Recipe {
	class UseCase: RecipeUseCaseProtocol {
		typealias Dependency = (
			ingredients: String,
			searchQuery: String,
			page: UInt
		)
		static func get(from dependency: Dependency) -> Future<(recipes: [ViewModels.RecipeViewModel], page: UInt)> {
			let (ingredients, searchQuery, page) = dependency
			let recipes = Recipe.Service.recipesFrom(ingredients: ingredients, searchQuery: searchQuery, page: page)
			return recipes
				.map(ViewModels.RecipeViewModel.map)
				.map { recipes in
					return (recipes: recipes, page: page)
			}
		}
	}
}
