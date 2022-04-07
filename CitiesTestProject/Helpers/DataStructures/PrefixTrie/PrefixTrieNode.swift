//
//  PrefixTrieNode.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 7.04.22.
//

import Foundation

fileprivate extension String {
	/// Custom subscript used to get concrete char in string by given index
	/// "Hello, World"[2] -> "i"
	subscript (i: Int) -> String {
		let start = index(startIndex, offsetBy: i)
		return String(self[start...start])
	}
}

extension PrefixTrie {
	class TrieNode<Element> {
		var value: String
		var childs: [String: TrieNode] = [:]
		var elements: [Element] = []

		init(value: String = "") {
			self.value = value
		}
	}
}

// MARK: - Insertion
extension PrefixTrie.TrieNode {
	func addChild(_ element: Element, extracted: String) {
		if value == extracted {
			self.elements.append(element)
		} else {
			let next = extracted[value.count]
			if let child = childs[next] {
				child.addChild(element, extracted: extracted)
			} else {
				childs[next] = PrefixTrie.TrieNode(value: value + next)
				childs[next]!.addChild(element, extracted: extracted)
			}
		}
	}
}

// MARK: - Elements search by query
extension PrefixTrie.TrieNode {
	func search(query: String) -> [Element] {
		if query.count == value.count {
			return elementsFromChilds()
		} else {
			let next = query[value.count]
			if let child = childs[next] {
				return child.search(query: query)
			} else {
				return []
			}
		}
	}
	
	private func elementsFromChilds() -> [Element] {
		var result = [Element]()
		for (_, child) in childs {
			result.append(contentsOf: child.elementsFromChilds())
		}
		return result + elements
	}
}
