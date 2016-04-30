import XCTest

import Foundation

@testable import Deflate

class TestDeflate : XCTestCase {
    
    static var allTests: [(String, TestDeflate -> () throws -> Void)] {
        return [
                   ("testDeflate", testDeflate),
                   ("testFindLongestSubstring", testFindLongestSubstring),
                   ("testDeflateOnBook", testDeflateOnBook)
        ]
    }
    
    func testDeflate() {
        
        let input: [Byte] = [0x80, 0x80, 0x80, 0x80, 0x40]
        
        let output = deflate(input)
        
        var correct = [Output]()
        correct.append( .value(0x80) )
        correct.append( .reference(Reference(length: 3, distance: 1)))
        correct.append( .value(0x40))
        
        print (output)
        
        XCTAssertEqual(output.count, correct.count)
        
        for i in 0...output.count-1 {
            XCTAssertEqual(output[i], correct[i])
        }
        
        //
        
    }
    
    func testDeflateInflate() {
        
        let input: [Byte] = [0x80, 0x70, 0x60, 0x80, 0x70, 0x60]
        
        let output = deflate(input)
        
        let decompressed = inflate(buffer: output)
        
        XCTAssertNotNil(decompressed)
        
        XCTAssertEqual(input, decompressed)
        
    }
    
    func testDeflateOnBook() {
        let data = NSData(contentsOfFile: "/Users/Robert/swift-at-ibm/gzip-compression/data/simple.txt")
        
        var bytes = [Byte](repeating: 0x00, count: data!.length)
        
        data?.getBytes(&bytes, length: (data?.length)!)
        
        let output = deflate(bytes)
        
        let stream = serialize(output: output)
        
        let compressionRatio = Double(stream.count)/Double(bytes.count)
        
        print("Compression ratio \(compressionRatio)")
        
    }
    
    func testDeflateInflateOnBook() {
        let data = NSData(contentsOfFile: "/Users/Robert/swift-at-ibm/gzip-compression/data/grinch.txt")
        
        var bytes = [Byte](repeating: 0x00, count: data!.length)
        
        data?.getBytes(&bytes, length: (data?.length)!)
        
        let output = deflate(bytes)
        
        let decompressed = inflate(buffer: output)
        
        XCTAssertNotNil(decompressed)
        
        XCTAssertEqual(bytes, decompressed)
        
    }
    
    func testSerialize() {
        let input: [Byte] = [0x80, 0x80, 0x80, 0x80, 0x40]
        let output = deflate(input)
        let serializedOutput = serialize(output: output)
        
        print(serializedOutput)
    }
    
    func testDeflate2() {
        
        let input: [Byte] = [0x80, 0x80, 0x40, 0x80, 0x80]
        
        let output = deflate(input)
        
        var correct = [Output]()
        correct.append( .value(0x80))
        correct.append( .value(0x80))
        correct.append( .value(0x40))
        correct.append( .reference(Reference(length: 2, distance: 3)))
        correct.append( .value(0x40))
        
        XCTAssertEqual(output.count, correct.count)
        
       
        print (output)
        //
        
    }

    
    /**
    The following test will use a hashmap to more quickly find the substring
    */
    func testFindSubstringFast() {
    
        let input: [Byte] = [0x81, 0x82, 0x83, 0x81, 0x82, 0x83, 0x81]
        
        var hashMap = ByteLookup()
        hashMap[0x81] = []
        hashMap[0x81]!.append(0)
        
        hashMap[0x82] = []
        hashMap[0x82]!.append(1)
        
        hashMap[0x83] = []
        hashMap[0x83]!.append(2)
        
        let reference = findLongestSubstringFast(index: 3, buffer: input, hashTable: hashMap)
        
        XCTAssertNotNil(reference)
        XCTAssertEqual(reference?.distance, 3)
        XCTAssertEqual(reference?.length, 4)
        
        hashMap[0x81]!.append(3)
        
        let reference2 = findLongestSubstringFast(index: 4, buffer: input, hashTable: hashMap)
        
        XCTAssertNotNil(reference2)
        XCTAssertEqual(reference2?.distance, 3)
        XCTAssertEqual(reference2?.length, 3)

        
        print(reference)
        
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
    
    func testFindLongestSubstring4() {
        
        let input: [Byte] = [0x01, 0x02, 0x03, 0x04, 0x02, 0x03, 0x04]
        
        let reference = findLongestSubstring(index: 4, buffer: input)
        
        XCTAssertNotNil(reference)
        
        let correct = Reference(length: 3, distance: 3)
        
        XCTAssertEqual(reference, correct)
        
        print(reference)
    }
}