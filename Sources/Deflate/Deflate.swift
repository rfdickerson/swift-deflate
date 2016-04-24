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


func deflate () {
    for i in input {
    
    // add current element to sliding window
    // check if it's in the window
    // if not, write to output
    // if it is, write reference to output
    window[index] = i
    
    // let reference = find(window, )
    
    output[index] = .reference( Reference( length: 8, distance: 3 ) )
    
    index += 1
    outputIndex += 1
    
    
    }

    print(window)

    print("Output is \(output)")

}