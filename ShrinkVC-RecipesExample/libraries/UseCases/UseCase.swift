//
//  RecipeUseCase.swift
//  MVVMRecipesExample
//
//  Created by Daniel Illescas Romero on 01/04/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

protocol UseCase {
	associatedtype ReturnElement
	associatedtype Dependency
	static func get(from dependency: Dependency) -> Future<ReturnElement>
}

// --

// test
/*protocol AuthenticationUseCaseProtocol: UseCase where ReturnElement == String {}

protocol RecipeUseCaseProtocol: UseCase where ReturnElement == Recipe.Service.Models.RecipeModel {
	associatedtype AuthenticationUseCase: AuthenticationUseCaseProtocol
}*/

