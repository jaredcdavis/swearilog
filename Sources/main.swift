import Foundation

var mysign : Signedness;

enum Error : ErrorProtocol {
    case FileError(msg: String);
}

let path = "LICENSE";
var fin : NSData? = NSData(contentsOfFile: path)
if fin == nil {
    throw Error.FileError(msg: "Error opening file \(path)");
}
else {

    let filesize = fin!.length;
    let bytes = UnsafePointer<UInt8>(fin!.bytes);

    var n = 0;
    while(n < filesize)
    {
        let byte = bytes[n];
        let char = UnicodeScalar(Int(byte));
        print(char, terminator:"");
        n = n + 1;
    }
}



let foo = "Foo";
let bar : String.UTF8View = foo.utf8;
let index : String.UTF8View.Index = bar.startIndex;

print("Bar is \(bar[index])")
print("Next is \(bar[index.successor()])")






try testAsciiCharStream()
