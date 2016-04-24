import XCTest

import Foundation

@testable import Deflate

class TestDeflate : XCTestCase {
    
    static var allTests: [(String, TestDeflate -> () throws -> Void)] {
        return [
                   ("testDeflate", testDeflate)
        ]
    }
    
    func testDeflate() {
        
        deflate()
        
    }
    
    /**
    * Should return a reference (1, 4)
    *
    */
    func testFindLongestSubstring() {
        let input: [Byte] = [0x80, 0x80, 0x80, 0x80]
        
        let reference = findLongestSubstring(index: 1, buffer: input)
        
        XCTAssertNotNil(reference)
        
        let correct = Reference(length: 3, distance: 1)
        XCTAssertEqual(reference, correct)
        
        print(reference)
    }
    
    /**
     * Should return a reference (1, 4)
     *
     */
    func testFindLongestSubstring2() {
        let input: [Byte] = [0x80, 0x40, 0x20, 0x80, 0x40, 0x20]
        
        let reference = findLongestSubstring(index: 3, buffer: input)
        
        XCTAssertNotNil(reference)
        
        let correct = Reference(length: 3, distance: 3)
        
        XCTAssertEqual(reference, correct)
        
        print(reference)
    }
    
    func testFindLongestSubstring3() {
        let input: [Byte] = [0x80, 0x40, 0x20, 0x80, 0x40, 0x20]
        
        let reference = findLongestSubstring(index: 2, buffer: input)
        
        XCTAssertNil(reference)
        
    }
}