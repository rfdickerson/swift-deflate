struct Block {
    
}

typealias Byte = UInt8

struct Reference {
    var length: UInt8
    var distance: UInt16
}

extension Reference: Equatable {}

func ==(lhs: Reference, rhs: Reference) -> Bool {
    let areEqual = lhs.distance == rhs.distance &&
        lhs.length == lhs.length
    return areEqual
}

enum Output {
    case reference(Reference)
    case value(Byte)
    case empty
}

extension Output: Equatable {}

func ==(lhs: Output, rhs: Output) -> Bool {
    return true
}

let input: [Byte] = [0x80, 0x23, 0x80, 0x23]

var window = [Byte](repeating: 0x00, count: 32768)
var index = 0


var outputIndex = 0

var output = [Output](repeating: .empty, count: input.count)

/**
 Finds a substring in the buffer
 
 - returns: Reference
*/
func findLongestSubstring(index: Int, buffer: [Byte]) -> Reference? {
    
    // find a substring that matches up to a part that can't be matched any longer
    assert(index >= 0 && index < buffer.count)
    
    if index == 0 {
        return nil
    }
    
    let toMatch = buffer[index]
    
    // Start looking at the end of the view
    var cursor = index-1
    
    // Look through the view for the starting character
    repeat {
        
        if buffer[cursor] == toMatch {
            
            var numCharactersMatched = 1
            
            while index + numCharactersMatched < buffer.count &&
                  buffer[cursor + numCharactersMatched] == buffer[index + numCharactersMatched] {
                
                numCharactersMatched+=1
            }
            
            
            if numCharactersMatched > 2 {
                return Reference(length: UInt8(numCharactersMatched), distance: UInt16(index-cursor))
            }
            
        }
        
        cursor -= 1
        
    } while cursor >= 0
    
    // Could not find a prefix with at least 3 characters long
    return nil
}


func deflate (buffer: [Byte]) -> [Output] {
    
    var output = [Output]()
    
    var cursor = 0
    while cursor < buffer.count {
        
        // try to obtain a back reference
        let reference = findLongestSubstring(index: cursor, buffer: buffer)
        
        if let reference = reference {
            output.append(.reference(reference))
            cursor += Int(reference.length) - Int(reference.distance)
        } else {
            output.append(.value(buffer[cursor]))
        }
        
        // slide view forward
        cursor += 1
    }
    
    return output
    

}