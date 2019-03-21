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
	
	public let observers: [ObserverAction<T, Int>]
	private var elements: CollectionType = []
	public var rawElements: CollectionType {
		return self.elements
	}
	
	public init(_ elements: CollectionType = [], observers: [ObserverAction<T, Int>] = []) {
		self.elements = elements
		self.observers = observers
	}
	
	public func addStubElements(count: Int, from element: CollectionType.Element) {
		let elements = [CollectionType.Element](repeating: element, count: count)
		self.elements.append(contentsOf: elements)
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
			for observer in self.observers {
				if case .append(let handler) = observer {
					handler((newElements: elements, firstIndex: self.elements.count - 1))
					break
				}
			}
		}
		return true
	}
	
	@discardableResult
	public func remove(at index: CollectionType.Index) -> Bool {
		guard self.elements.indices.contains(index) else { return false }
		let removedElement = self.elements.remove(at: index)
		DispatchQueue.main.async {
			for observer in self.observers {
				if case .remove(let handler) = observer {
					handler((removedElement: removedElement, elementIndex: index))
					break
				}
			}
		}
		return true
	}
	
	@discardableResult
	public func removeAll(keepingCapacity: Bool = false) -> Bool {
		if self.elements.isEmpty { return false }
		let firstRemovedElement = self.elements.first ?? self.elements[0]
		let lastRemovedElement = self.elements.last ?? self.elements[0]
		let removedIndices = self.elements.indices
		self.elements.removeAll(keepingCapacity: keepingCapacity)
		DispatchQueue.main.async {
			for observer in self.observers {
				if case .removeAll(let handler) = observer {
					handler((firstElement: firstRemovedElement, lastElement: lastRemovedElement, indices: removedIndices))
					break
				}
			}
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
		let indicesRange = index..<(index+elements.count)
		DispatchQueue.main.async {
			for observer in self.observers {
				if case .insert(let handler) = observer {
					handler((insertedElements: elements, indices: indicesRange))
					break
				}
			}
		}
		return true
	}
	
	@discardableResult
	public func update(elementAt index: CollectionType.Index, _ foundElementHandler: (T) -> T) -> Bool {
		guard let element = self[safe: index] else { return false }
		self.elements[index] = foundElementHandler(element)
		DispatchQueue.main.async {
			for observer in self.observers {
				if case .update(let handler) = observer {
					handler((updatedElement: element, index: index))
					break
				}
			}
		}
		return true
	}
	
	@discardableResult
	public func move(from sourceIndex: CollectionType.Index, to destinationIndex: CollectionType.Index) -> Bool {
		guard let elementToMove = self[safe: sourceIndex], self.elements.indices.contains(destinationIndex) else { return false }
		self.elements.remove(at: sourceIndex)
		self.elements.insert(elementToMove, at: destinationIndex)
		DispatchQueue.main.async {
			for observer in self.observers {
				if case .move(let handler) = observer {
					handler((source: (element: elementToMove, index: sourceIndex), destinationIndex: destinationIndex))
					break
				}
			}
		}
		return true
	}
}
