//
//  ViewController.swift
//  MVVMExample
//
//  Created by Daniel Illescas Romero on 20/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import UIKit

class RecipesTableViewController: UITableViewController {
	
	typealias RecipeVM = Recipe.UseCase.ViewModels.RecipeViewModel

	private var tableViewDataSource: RecipesTableViewDataSource!
	private var elements: ObservableArray<RecipeVM> {
		return self.tableViewDataSource.observableData
	}
	
	override func viewDidLoad() {
		self.setupUI()
		self.setupController()
		self.setupLocalization()
		
		self.tableViewDataSource.fetchOptions.ingredients = "garlic"
		self.tableViewDataSource.fetchRecipes(page: 0)
	}
}

extension RecipesTableViewController: ViewControllerSetupProtocol {
	
	func setupUI() {
		self.navigationItem.setRightBarButton(self.editButtonItem, animated: true)
	}
	
	func setupController() {
		let adapter = TableViewAdapter(component: self.tableView, initialElements: [RecipeVM]())
		self.tableViewDataSource = RecipesTableViewDataSource(adapter: adapter, useCases: (Recipe.UseCase.self, Recipe.UseCase.self))
		self.tableView.dataSource = self.tableViewDataSource
		self.tableView.delegate = self.tableViewDataSource
		self.tableView.prefetchDataSource = self.tableViewDataSource
	}
	
	func setupLocalization() {
		self.title = "Lol"
	}
}
