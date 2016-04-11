func testAsciiChar()
{
    assert(AsciiCharFromCharacter("A") == 65)
    assert(CharacterFromAsciiChar(65) == "A")

    // Conversion from ASCII to Unicode then back must be sane.
    for i in 0...255 {
        let origChar : AsciiChar = AsciiChar(i);
        let index = CharacterFromAsciiChar(origChar);
        let newChar : AsciiChar = AsciiCharFromCharacter(index)!;
        assert(origChar == newChar);
    }

    // Unicode values that are too large must NOT map to ASCII values.
    for i in 256...500 {
        let char = Character(UnicodeScalar(i));
        assert(AsciiCharFromCharacter(char) == nil);
    }
}


func testHelloWorld(stream : AsciiCharStream)
{
    print("Testing Hello World stream... ", terminator:"");

    func at(line : UInt, col : UInt, char : UInt) -> Void {
        assert(stream.getLineNumber() == line);
        assert(stream.getColNumber() == col);
        assert(stream.getCharNumber() == char);
    }

    func read(expect : Character, line: UInt, col: UInt, char: UInt) -> Void {
        let actual = stream.getChar()!;
        assert(actual == AsciiCharFromCharacter(expect));
        at(line, col: col, char: char);
    }

    at(1, col: 0, char: 0);

    read("H", line: 1, col: 1, char: 1);

    try! stream.ungetChar();
    at(1, col: 0, char: 0);

    read("H", line: 1, col: 1, char: 1);

    try! stream.ungetChar();
    at(1, col: 0, char: 0);

    read("H", line: 1, col: 1, char: 1);
    read("e", line: 1, col: 2, char: 2);

    try! stream.ungetChar();
    at(1, col: 1, char: 1);

    // This should fail because we've already ungotten it.
    let xx : Void? = try? stream.ungetChar();
    assert(xx == nil);

    read("e", line: 1, col: 2, char: 2);
    read("l", line: 1, col: 3, char: 3);
    read("l", line: 1, col: 4, char: 4);
    read("o", line: 1, col: 5, char: 5);

    read("\n", line: 2, col: 0, char: 6);

    try! stream.ungetChar();
    at(1, col: 5, char: 5);

    read("\n", line: 2, col: 0, char: 6);
    read("W", line: 2, col: 1, char: 7);
    try! stream.ungetChar();
    at(2, col: 0, char: 6);

    read("W", line: 2, col: 1, char: 7);
    read("o", line: 2, col: 2, char: 8);
    read("r", line: 2, col: 3, char: 9);
    read("l", line: 2, col: 4, char: 10);
    read("d", line: 2, col: 5, char: 11);
    let end = stream.getChar();
    assert(end == nil);
    let end2 = stream.getChar();
    assert(end2 == nil);

    print("ok.")
    return;
}

func testAsciiCharStream() throws -> Void
{
    testAsciiChar()

    let stream = AsciiStringReader(str: "Hello\nWorld");
    testHelloWorld(stream);
}
