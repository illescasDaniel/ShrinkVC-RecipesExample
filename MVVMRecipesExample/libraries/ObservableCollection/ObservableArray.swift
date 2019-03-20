//
//  ObservableArray.swift
//  MVVMExample
//
//  Created by Daniel Illescas Romero on 20/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

final public class ObservableArray<T>: ObservableCollection, CustomStringConvertible {
	
	public typealias CollectionType = [T]
	
	public let observers: [ObserverAction: ObserverHandler]
	private var elements: CollectionType = []
	public var rawElements: CollectionType {
		return self.elements
	}
	
	public init(_ elements: CollectionType = [], observers: [ObserverAction: ObserverHandler] = [:]) {
		self.elements = elements
		self.observers = observers
	}
	
	@discardableResult
	public func append(_ elements: CollectionType.Element...) -> Bool {
		return self.append(elements)
	}
	
	@discardableResult
	public func append(_ elements: [CollectionType.Element]) -> Bool {
		if elements.isEmpty { return false }
		self.elements.append(contentsOf: elements)
		DispatchQueue.main.async {
			self.observers[.append]?(elements[0], [self.elements.count - 1])
		}
		return true
	}
	
	@discardableResult
	public func remove(at index: CollectionType.Index) -> Bool {
		guard self.elements.indices.contains(index) else { return false }
		let removedElement = self.elements.remove(at: index)
		DispatchQueue.main.async {
			self.observers[.remove]?(removedElement, [index])
		}
		return true
	}
	
	@discardableResult
	public func removeAll(keepingCapacity: Bool = false) -> Bool {
		if self.elements.isEmpty { return false }
		let lastRemovedElement = self.elements.last ?? self.elements[0]
		let lastElementIndex = self.elements.count - 1
		self.elements.removeAll(keepingCapacity: keepingCapacity)
		DispatchQueue.main.async {
			self.observers[.removeAll]?(lastRemovedElement, [lastElementIndex])
		}
		return true
	}
	
	@discardableResult
	public func insert(_ elements: CollectionType.Element..., at index: CollectionType.Index) -> Bool {
		return self.insert(elements, at: index)
	}
	
	@discardableResult
	public func insert(_ elements: [CollectionType.Element], at index: CollectionType.Index) -> Bool {
		guard !elements.isEmpty
			&& (self.elements.indices.lowerBound...self.elements.indices.upperBound).contains(index) else { return false }
		self.elements.insert(contentsOf: elements, at: index)
		DispatchQueue.main.async {
			self.observers[.insert]?(elements[0], Array(index..<(index+elements.count)))
		}
		return true
	}
	
	@discardableResult
	public func update(elementAt index: CollectionType.Index, _ foundElementHandler: (T) -> T) -> Bool {
		guard let element = self[safe: index] else { return false }
		self.elements[index] = foundElementHandler(element)
		DispatchQueue.main.async {
			self.observers[.update]?(element, [index])
		}
		return true
	}
	
	@discardableResult
	public func move(from sourceIndex: CollectionType.Index, to destinationIndex: CollectionType.Index) -> Bool {
		guard let elementToMove = self[safe: sourceIndex], self.elements.indices.contains(destinationIndex) else { return false }
		self.elements.remove(at: sourceIndex)
		self.elements.insert(elementToMove, at: destinationIndex)
		DispatchQueue.main.async {
			self.observers[.move]?(elementToMove, [sourceIndex, destinationIndex])
		}
		return true
	}
}
