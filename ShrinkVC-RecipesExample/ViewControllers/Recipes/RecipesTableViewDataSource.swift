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
	
	typealias RecipeVM = Recipe.UseCase.ViewModels.RecipeViewModel
	
	private let tableViewAdapter: TableViewAdapter<UITableView, RecipeVM>
	private let useCases: (recipeUseCase: Recipe.UseCase.Type, otherUseCase: Recipe.UseCase.Type)

	var fetchOptions: (ingredients: String, searchQuery: String, page: UInt) = ("", "", 1)
	var observableData: ObservableArray<RecipeVM> {
		return self.tableViewAdapter.observableElements
	}
	
	init(adapter: TableViewAdapter<UITableView, RecipeVM>, useCases: (recipeUseCase: Recipe.UseCase.Type, otherUseCase: Recipe.UseCase.Type)) {
		self.tableViewAdapter = adapter
		
		self.tableViewAdapter.observableElements.addStubElements(count: 100, from: RecipeVM(model: .mock))
		self.useCases = useCases
	}
	
	// MARK: - UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.observableData.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
			return .init()
		}
		if self.observableData[safe: indexPath.row]?.emptyState == true {
			cell.textLabel?.text = "--"
			cell.detailTextLabel?.text = "--"
			self.fetchRecipes(for: indexPath)
		} // else, the values will be asynchronously loaded into the cell in the willDisplay method
		if ((indexPath.row + 1) % 50 == 0) && self.observableData.count < (indexPath.row + 50) {
			self.observableData.append([RecipeVM](repeating: RecipeVM(model: .mock), count: 50))
		}
		return cell
	}
}

// MARK: - UITableViewDelegate
extension RecipesTableViewDataSource: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		DispatchQueue.main.async {
			if let recipe = self.observableData[safe: indexPath.row], !recipe.emptyState {
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
	func fetchRecipes(page: UInt) {
		self.useCases.recipeUseCase.get(from: (ingredients: self.fetchOptions.ingredients,
								   searchQuery: self.fetchOptions.searchQuery,
								   page: page)).then
		{ recipes, page in

			let page = Int(page)
			let (startIndex, endIndex) = ((page-1) * 10, page * 10)
			for (index, recipe) in zip((startIndex..<endIndex), recipes) {
				
				self.observableData[safe: index]?.emptyState = false
				self.observableData[safe: index]?.model.title = recipe.titleText
				self.observableData[safe: index]?.model.ingredients = recipe.ingredientsText
				
				DispatchQueue.main.async {
					if let cell = self.tableViewAdapter.viewComponent?.cellForRow(at: IndexPath(row: index, section: self.tableViewAdapter.section)) {
						cell.textLabel?.text = recipe.titleText
						cell.detailTextLabel?.text = recipe.ingredientsText
					}
				}
			}
		}
	}
	func fetchRecipes(for indexPath: IndexPath) {
		
		guard indexPath.row % 10 == 0 else { return }
		
		
		let page = (indexPath.row / 10) + 1
		let (startIndex, endIndex) = ((page-1) * 10, page * 10)
		if self.observableData[safe: startIndex]?.emptyState == true || self.observableData[safe: endIndex]?.emptyState == true {
			print("called")
			self.fetchRecipes(page: UInt(page))
		}
		
		/*guard indexPath.row >= (self.fetchOptions.page * 10) else { return }
		self.fetchOptions.page += 1
		self.fetchRecipes()*/
	}
}

