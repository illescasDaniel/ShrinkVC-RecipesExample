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
	private var section: Int
	
	public init(component: Component, initialElements elements: Elements, section: Int = 0) {
		self.section = section
		self.component = component
		self.observableElements = ObservableArray<ElementType>(elements, observers: [
			.append: { (newElement, indices) in
				self.component?.reloadData()
			},
			.remove: { (removedElement, indices) in
				self.component?.deleteRows(at: [IndexPath.init(row: indices[0], section: section)], with: .automatic)
			},
			.removeAll: { (lastElementRemoved, lastRemovedElement) in
				self.component?.reloadSections(IndexSet(integer: section), with: .automatic)
			},
			.insert: { (insertedElement, indices) in
				let indexPaths = indices.map { IndexPath(row: $0, section: section) }
				self.component?.insertRows(at: indexPaths, with: .automatic)
			},
			.move: { (movedElement, indices) in
				self.component?.moveRow(at: IndexPath(row: indices[0], section: section), to: IndexPath(row: indices[1], section: section))
			},
			.update: { (movedElement, indices) in
				self.component?.reloadRows(at: [IndexPath(row: indices[0], section: section)], with: .automatic)
			}
		])
	}
}

