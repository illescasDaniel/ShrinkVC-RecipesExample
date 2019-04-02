//
//  TODOServiceViewModels.swift
//  ProjectTemplate
//
//  Created by Daniel Illescas Romero on 10/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import UIKit

extension Recipe.UseCase {
	enum ViewModels {
		
		struct RecipeViewModel: ViewModel {
			
			var model: Recipe.Service.Models.RecipeModel
			var emptyState = true
			
			init(model: Recipe.Service.Models.RecipeModel) {
				self.model = model
			}
			
			var titleText: String {
				return self.model.title.trimmingCharacters(in: .whitespacesAndNewlines)
			}
			var ingredientsText: String {
				return self.model.ingredients.trimmingCharacters(in: .whitespacesAndNewlines)
			}
		}
	}
}
