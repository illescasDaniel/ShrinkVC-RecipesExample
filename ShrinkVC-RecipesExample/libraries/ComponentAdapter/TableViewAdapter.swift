//
//  TableViewAdapter.swift
//  MVVMExample
//
//  Created by Daniel Illescas Romero on 20/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import UIKit

final public class TableViewAdapter<Component: UITableView, ElementType>: ComponentAdapter {
	
	public typealias Elements = [ElementType]
	
	public var observableElements = ObservableArray<ElementType>()
	private weak var component: Component?
	let section: Int
	
	var viewComponent: Component? {
		return self.component
	}
	
	public init(component: Component, initialElements elements: Elements, section: Int = 0) {
		self.section = section
		self.component = component
		self.observableElements = ObservableArray<ElementType>(elements, observers: [
			.append { (newElements, firstIndex) in
				DispatchQueue.main.async {
					self.component?.reloadData()
				}
			},
			.remove { (removedElement, index) in
				DispatchQueue.main.async {
					self.component?.deleteRows(at: [IndexPath(row: index, section: section)], with: .automatic)
				}
			},
			.removeAll { (firstElement, lastElement, indices) in
				DispatchQueue.main.async {
					self.component?.reloadSections(IndexSet(integer: section), with: .automatic)
				}
			},
			.insert { (insertedElements, indices) in
				DispatchQueue.main.async {
					let indexPaths = indices.map { IndexPath(row: $0, section: section) }
					self.component?.insertRows(at: indexPaths, with: .automatic)
				}
			},
			.move { (source, destinationIndex) in
				DispatchQueue.main.async {
					self.component?.moveRow(at: IndexPath(row: source.index, section: section), to: IndexPath(row: destinationIndex, section: section))
				}
			},
			.update { (updatedElement, index) in
				DispatchQueue.main.async {
					self.component?.reloadRows(at: [IndexPath(row: index, section: section)], with: .automatic)
				}
			}
		])
	}
}

