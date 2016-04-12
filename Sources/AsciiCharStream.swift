import Foundation

typealias AsciiChar = UInt8

func CharacterFromAsciiChar(ascii : AsciiChar) -> Character
{
    return Character(UnicodeScalar(ascii));
}

func AsciiCharFromCharacter(char : Character) -> AsciiChar?
{
    let str = String(char)
    let scalars = str.unicodeScalars
    let start = scalars.startIndex
    let val = scalars[start].value
    if (val < 256) {
        return AsciiChar(val)
    }
    return nil
}


protocol AsciiCharStream
{
    func ungetChar() throws -> Void
    func getChar() -> AsciiChar?
    func peekChar() -> AsciiChar?
    func getLineNumber() -> UInt
    func getColNumber() -> UInt
    func getCharNumber() -> UInt
}

enum AsciiCharStreamError : ErrorProtocol
{
    case DoubleUnget;
    case UngetAtStart;
}

internal class AsciiPositionTracker
{
    private let NEWLINE : AsciiChar = 10;

    // Position tracking.
    private var place : UInt;
    private var line : UInt;
    private var col : UInt;

    // Previous place tracking.
    private var prevPlace : UInt;
    private var prevLine : UInt;
    private var prevCol : UInt;

    init()
    {
        place = 0;
        line = 1;
        col = 0;
        prevPlace = 0;
        prevLine = 1;
        prevCol = 0;
    }

    func atStart() -> Bool
    {
        return place == 0;
    }

    func getLineNumber () -> UInt { return line; }
    func getColNumber() -> UInt { return col; }
    func getCharNumber() -> UInt { return place; }

    func updateForRead(char : AsciiChar)
    {
        prevPlace = place;
        prevLine = line;
        prevCol = col;
        place = place + 1;
        if (char == NEWLINE) {
            line = line + 1;
            col = 0;
        }
        else {
            col = col + 1;
        }
    }

    func updateForUnget()
    {
        assert(!atStart());
        place = prevPlace;
        line = prevLine;
        col = prevCol;
    }
}


public class AsciiStringReader : AsciiCharStream
{
    private let data : String.UTF8View;        // Data we are iterating through
    private var curr : String.UTF8View.Index;  // Current place in the string (has the next char to read)
    private let end : String.UTF8View.Index;   // End of string (so we can stop)
    private var pos : AsciiPositionTracker;    // Line/column number tracker
    private var prevChar : AsciiChar;          // Character we read last (so we can unget it.)
    private var haveUnget : Bool;              // Have we just done an unget? (if so we can't unget again)

    public init(str: String)
    {
        data = str.utf8;
        curr = data.startIndex;
        end = data.endIndex;
        pos = AsciiPositionTracker();
        prevChar = 0;
        haveUnget = false;
    }

    func ungetChar() throws -> Void
    {
        if (haveUnget) {
            throw AsciiCharStreamError.DoubleUnget;
        }
        if (pos.atStart()) {
            throw AsciiCharStreamError.UngetAtStart;
        }
        pos.updateForUnget();     // Switch to previous position
        haveUnget = true;
    }

    func peekChar() -> AsciiChar?
    {
        if (haveUnget) {
            return prevChar;
        }
        else if (curr == end) {
            return nil;
        }
        else {
            return data[curr];
        }
    }

    func getChar() -> AsciiChar?
    {
        if (haveUnget) {
            haveUnget = false;
            pos.updateForRead(prevChar);
            return prevChar;
        }
        else if (curr == end) {
            return nil;
        }
        else {
            let ans = data[curr];
            curr = curr.successor();
            pos.updateForRead(ans);
            prevChar = ans;
            return ans;
        }
    }

    func getLineNumber() -> UInt { return pos.getLineNumber(); }
    func getColNumber() -> UInt { return pos.getColNumber(); }
    func getCharNumber() -> UInt { return pos.getCharNumber(); }
}



enum AsciiFileReaderError : ErrorProtocol
{
    case FileError(msg: String);
}

public class AsciiFileReader : AsciiCharStream
{
    // Raw handle to data object -- I didn't expect to need this, but without
    // it the reading doesn't seem to work, presumably because it gets garbage
    // collected?? Really??
    private let data : NSData;

    private let filename : String;                  // Path we are reading from
    private let bytes : UnsafePointer<UInt8>;       // Bytes for this file
    private let len : Int;                          // Length of this file in bytes
    private var curr : Int;                         // Current place in the file
    private var pos : AsciiPositionTracker;         // Line/column number tracker
    private var prevChar : AsciiChar;               // Character we read last (so we can unget it.)
    private var haveUnget : Bool;                   // Have we just done an unget? (if so we can't unget again)

    public init(path: String) throws
    {
        filename = path;
        let fdata : NSData? = NSData(contentsOfFile: filename);
        if (fdata == nil) {
            throw AsciiFileReaderError.FileError(msg: "Error opening \(filename)");
        }
        data = fdata!;
        bytes = UnsafePointer<UInt8>(data.bytes);
        len = data.length;
        curr = 0;
        pos = AsciiPositionTracker();
        prevChar = 0;
        haveUnget = false;
    }

    deinit {
        // BOZO deinitialize?
    }

    func ungetChar() throws -> Void
    {
        if (haveUnget) {
            throw AsciiCharStreamError.DoubleUnget;
        }
        else if (pos.atStart()) {
            throw AsciiCharStreamError.UngetAtStart;
        }
        else {
            pos.updateForUnget();     // Switch to previous position
            haveUnget = true;
        }
    }

    func peekChar() -> AsciiChar?
    {
        if (haveUnget) {
            return prevChar;
        }
        else if (curr == len) {
            return nil;
        }
        else {
            return bytes[curr];
        }
    }

    func getChar() -> AsciiChar?
    {
        if (haveUnget) {
            haveUnget = false;
            pos.updateForRead(prevChar);
            return prevChar;
        }
        else if (curr == len) {
            return nil;
        }
        else {
            let ans = bytes[curr];
            curr = curr + 1;
            pos.updateForRead(ans);
            prevChar = ans;
            return ans;
        }
    }

    func getLineNumber() -> UInt { return pos.getLineNumber(); }
    func getColNumber() -> UInt { return pos.getColNumber(); }
    func getCharNumber() -> UInt { return pos.getCharNumber(); }
}

