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
        trie.insert(bytes: input, index: 0)
        
        trie.insert(bytes: input2, index: 1)
        
        XCTAssertEqual(trie.final, false)
        
        
        
        
    }
    
    func testContains() {
        
        let input: [Byte] = [0x80, 0x80, 0x80, 0x80, 0x40]
        let input2: [Byte] = [0x80, 0x80, 0x80, 0x80, 0x42]
        
        let testInput: [Byte] = [0x01, 0x02, 0x03, 0x04, 0x05]
        
        let trie = TrieNode()
        trie.insert(bytes: input, index: 0)
        trie.insert(bytes: input2, index: 1)
        
        let found = trie.contains(bytes: input)
        
        XCTAssertEqual(found, [0])
        
        let found2 = trie.contains(bytes: testInput)
        
        XCTAssertEqual(found2, [])
        
        // XCTAssertFalse(found2)
        
        
    }
    
    
}