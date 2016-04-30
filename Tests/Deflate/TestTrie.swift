//
//  TestTrie.swift
//  PureDeflate
//
//  Created by Robert Dickerson on 4/30/16.
//
//

import XCTest

import Foundation

@testable import Deflate


class TestTrie : XCTestCase {

    func testInsert() {
        let input: [Byte] = [0x80, 0x80, 0x80, 0x80, 0x40]
        let input2: [Byte] = [0x80, 0x80, 0x80, 0x80, 0x42]

        
        let trie = TrieNode()
        trie.insert(bytes: input)
        
        trie.insert(bytes: input2)
        
        XCTAssertEqual(trie.final, false)
        
        
    }
}