//
//  TODOBusinessModels.swift
//  ProjectTemplate
//
//  Created by Daniel Illescas Romero on 10/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

extension Recipe.Service {
	enum Models {
		struct RecipeModel: MappableArrayModel, MockableModel {
			var title: String
			let url: URL
			var ingredients: String
			let thumbnail: String
			typealias EndpointModel = Recipe.Internal.ApiClient.Models.RecipeResponse
			static func map(from endpointModel: EndpointModel) -> [RecipeModel] {
				return endpointModel.results.map { RecipeModel(title: $0.title, url: $0.href, ingredients: $0.ingredients, thumbnail: $0.thumbnail) }
			}
			static var mock: RecipeModel {
				return RecipeModel.init(title: "--", url: URL(string: "http://www.google.com")!, ingredients: "--", thumbnail: "http://www.google.com")
			}
		}
	}
}


