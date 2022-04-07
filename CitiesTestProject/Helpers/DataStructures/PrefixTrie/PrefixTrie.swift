//
//  PrefixTrie.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 7.04.22.
//

import Foundation

class PrefixTrie<Element> {
	typealias Node = TrieNode<Element>
	typealias StringMapper = (Element) -> String
	typealias PreCompareMapper = (String) -> String
	
	var root: Node
	
	/// Provided to let data structure know about how to represent given object to string because of prefix trie will work only with this data type under the hood
	let elementStringMapper: StringMapper
	
	/// Provided to establish user pre-defined comparasion rules during search
	/// For example to accomplish with case insensitive search
	/// { $0.lowercased() } - which will meen that Node will try to cast all strings to lowercase and in future it would be easy to search with both lowercase and uppercase inputs
	let preCompareMapper: PreCompareMapper

	init(root: Node = Node(),
		 elementStringMapper: @escaping StringMapper,
		 preCompareMapper: @escaping PreCompareMapper) {
		self.root = root
		self.elementStringMapper = elementStringMapper
		self.preCompareMapper = preCompareMapper
	}
	
	func insert(element: Element) {
		let extracted = preCompareMapper(elementStringMapper(element))
		root.addChild(element, extracted: extracted)
	}
	
	func search(query: String) -> [Element] {
		let mappedQuery = preCompareMapper(query)
		return root.search(query: mappedQuery)
	}
	
	func changeRootNode(with node: Node) {
		self.root = node
	}
	
	static func produceNodesChain(with elements: [Element], elementStringMapper: StringMapper, preCompareMapper: PreCompareMapper) -> Node {
		let rootNode = Node()
		elements.forEach {
			let extracted = preCompareMapper(elementStringMapper($0))
			rootNode.addChild($0, extracted: extracted)
		}
		return rootNode
	}
}
