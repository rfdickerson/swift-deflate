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
}