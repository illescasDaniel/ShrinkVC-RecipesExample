//
//  RecipesTableViewDataSource.swift
//  MVVMExample
//
//  Created by Daniel Illescas Romero on 20/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import UIKit

// TODO: be able to delete some elements of 'observableData' to save memory space
class RecipesTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
	
	typealias RecipeVM = Recipe.Service.ViewModels.RecipeViewModel
	
	private let tableViewAdapter: TableViewAdapter<UITableView, RecipeVM>

	var fetchOptions: (ingredients: String, searchQuery: String, page: UInt) = ("", "", 1)
	var observableData: ObservableArray<RecipeVM> {
		return self.tableViewAdapter.observableElements
	}
	
	init(adapter: TableViewAdapter<UITableView, RecipeVM>) {
		self.tableViewAdapter = adapter
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.observableData.count
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		DispatchQueue.main.async {
			if let recipe = self.observableData[safe: indexPath.row] {
				cell.textLabel?.text = recipe.titleText
				cell.detailTextLabel?.text = recipe.ingredientsText
			}
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
			return .init()
		}
		if self.observableData[safe: indexPath.row] == nil {
			cell.textLabel?.text = "--"
			cell.detailTextLabel?.text = "--"
		}
		DispatchQueue.main.async {
			let pageLoadOffset = 3
			if (indexPath.row + 1 + pageLoadOffset) > self.observableData.count {
				self.fetchOptions.page += 1
				self.fetchRecipes()
			}
		}
		return cell
	}
}

extension RecipesTableViewDataSource {
	func fetchRecipes() {
		Recipe.Service.recipesFrom(ingredients: self.fetchOptions.ingredients,
								   searchQuery: self.fetchOptions.searchQuery,
								   page: self.fetchOptions.page).then { recipes in
			self.observableData.append(recipes)
		}
	}
}
