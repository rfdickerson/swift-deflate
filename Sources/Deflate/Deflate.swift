struct Block {
    
}

typealias Byte = UInt8

struct Reference {
    var length: UInt8
    var distance: UInt16
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
func find(buffer: [Byte], substring: [Byte]) -> Reference {
    
    // find a substring that matches up to a part that can't be matched any longer
    
    return Reference(length: 0, distance: 0)
}


func deflate () {
    for i in input {
    
    // add current element to sliding window
    // check if it's in the window
    // if not, write to output
    // if it is, write reference to output
    window[index] = i
    
    
    output[index] = .reference( Reference( length: 8, distance: 3 ) )
    
    index += 1
    outputIndex += 1
    
    
    }

    print(window)

    print("Output is \(output)")

}