//
//  RecipesTableViewDataSource.swift
//  MVVMExample
//
//  Created by Daniel Illescas Romero on 20/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import UIKit

// TODO: be able to delete some elements of 'observableData' to save memory space
class RecipesTableViewDataSource: NSObject, UITableViewDataSource {
	
	typealias RecipeVM = Recipe.Service.ViewModels.RecipeViewModel
	
	private let tableViewAdapter: TableViewAdapter<UITableView, RecipeVM>

	var fetchOptions: (ingredients: String, searchQuery: String, page: UInt) = ("", "", 1)
	var observableData: ObservableArray<RecipeVM> {
		return self.tableViewAdapter.observableElements
	}
	
	init(adapter: TableViewAdapter<UITableView, RecipeVM>) {
		self.tableViewAdapter = adapter
	}
	
	// MARK: - UITableViewDataSource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.observableData.count + 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
			return .init()
		}
		if !self.observableData.rawElements.indices.contains(indexPath.row) {
			cell.textLabel?.text = "-loading-"
			cell.detailTextLabel?.text = "-loading-"
			self.fetchRecipes(for: indexPath)
		} // else, the values will be asynchronously loaded into the cell in the willDisplay method
		return cell
	}
}

// MARK: - UITableViewDelegate
extension RecipesTableViewDataSource: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		DispatchQueue.main.async {
			if let recipe = self.observableData[safe: indexPath.row] {
				cell.textLabel?.text = recipe.titleText
				cell.detailTextLabel?.text = recipe.ingredientsText
			}
		}
	}
}

// MARK: - UITableViewDataSourcePrefetching
extension RecipesTableViewDataSource: UITableViewDataSourcePrefetching {
	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		for indexPath in indexPaths {
			self.fetchRecipes(for: indexPath)
		}
	}
}

// MARK: - Convenience
extension RecipesTableViewDataSource {
	func fetchRecipes() {
		Recipe.Service.recipesFrom(ingredients: self.fetchOptions.ingredients,
								   searchQuery: self.fetchOptions.searchQuery,
								   page: self.fetchOptions.page).then { recipes in
			self.observableData.append(recipes)
		}
	}
	func fetchRecipes(for indexPath: IndexPath) {
		guard indexPath.row >= (self.fetchOptions.page * 10) else { return }
		self.fetchOptions.page += 1
		self.fetchRecipes()
	}
}

