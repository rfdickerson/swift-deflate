struct Block {
    
}

typealias Byte = UInt8

struct Reference {
    var length: Int
    var distance: Int
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



/**
 Finds a substring in the buffer
 
 - returns: Reference
*/
func findLongestSubstring( index: Int, buffer: [Byte]) -> Reference? {
    
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
                return Reference(length: numCharactersMatched, distance: index-cursor)
            }
            
        }
        
        cursor -= 1
        
    } while cursor >= 0
    
    // Could not find a prefix with at least 3 characters long
    return nil
}


func deflate (_ buffer: [Byte]) -> [Output] {
    
    var output = [Output]()
    
    var cursor = 0
    while cursor < buffer.count {
        
        // try to obtain a back reference
        let reference = findLongestSubstring(index: cursor, buffer: buffer)
        
        if let reference = reference {
            output.append(.reference(reference))
            cursor += Int(reference.length)
        } else {
            output.append(.value(buffer[cursor]))
            cursor += 1
        }
        
        // slide view forward
        
    }
    
    return output
    

}

func inflate (buffer: [Output]) -> [Byte] {
    
    var output = [Byte]()

    var index = 0
    while index < buffer.count {
        
        let cursor = buffer[index]
        let outputIndex = output.count
        
        switch cursor {
        case .empty:
            break
        case .reference(let reference):
            for j in 0...reference.length-1 {
                
                let newIndex = outputIndex - reference.distance + j
                output.append(output[newIndex])
            }
        case .value(let value):
            output.append(value)
        }
        
        index += 1
    }
    
    return output
}

func serialize( output: [Output]) -> [Byte] {
    
    var serializedOutput = [Byte]()
    
    for i in output {
        switch i {
        case .reference(let ref):
            serializedOutput.append(UInt8(ref.length))
            serializedOutput.append(UInt8((ref.distance & 0xFF00) >> 8))
            serializedOutput.append(UInt8(ref.distance & 0x00FF))
        case .value(let value):
            serializedOutput.append(value)
        case .empty:
            break
        }
    }
    
    return serializedOutput
    
}