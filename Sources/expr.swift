typealias BigInt = Int
//typealias AsciiChar = UInt8
typealias AsciiString = [AsciiChar]

enum Signedness
{
    case Signed;
    case Unsigned;
}

enum LeftRight
{
    case Left;
    case Right;
}

enum Bit
{
    case Bit0;
    case Bit1;
    case BitX;
    case BitZ;
}

enum TimeUnit
{
    case S;
    case MS;
    case US;
    case NS;
    case PS;
    case FS;
}

enum RandomQualifier
{
    case None;
    case Rand;
    case RandC;
}

enum Value
{
    case ConstInt(value: BigInt,
                  origWidth: Int,
                  origSign: Signedness,
                  wasUnsized: Bool);

    case WeirdInt(bits: [Bit],
                  origWidth: Int,
                  origSign: Signedness,
                  wasUnsigned: Bool);

    case ExtInt(value: Bit);

    case Real(value: Double);

    case Time(quantity: String,
              units: TimeUnit);

    case Str(value: AsciiString);
}

enum CoreTypeName
{
    case Logic;
    case Reg;
    case Bit;
    case Byte;
    case ShortInt;
    case Int;
    case LongInt;
    case Integer;
    case Time;
    case ShortReal;
    case Real;
    case RealTime;
    case String;
    case CHandle;
    case Event;
    case Void;
    case Sequence;
    case Property;
    case Untyped;
}

enum ScopeName
{
    case Local;
    case Unit;
    case Package(AsciiString);
}

enum HidName
{
    case Root;
    case Name(AsciiString);
}

enum UnaryOp
{
    case Plus;
    case Minus;
    case Lognot;
    case Bitnot;
    case Bitand;
    case Nand;
    case Bitor;
    case Nor;
    case Xor;
    case Xnor;
    case PreInc;
    case PreDec;
    case PostInc;
    case PostDec;

    func str() -> String
    {
        switch(self)
        {
            case .Plus: return "+";
            case .Minus: return "-";
            case .Lognot: return "!";
            case .Bitnot: return "~";
            case .Bitand: return "&";
            case .Nand: return "~&";
            case .Bitor: return "|";
            case .Nor: return "~|";
            case .Xor: return "^";
            case .Xnor: return "~^";
            case .PreInc: return "++";
            case .PreDec: return "--";
            case .PostInc: return "++";
            case .PostDec: return "--";
        }
    }
}

enum BinaryOp
{
    case BinaryPlus;
    case BinaryMinus;
    case BinaryTimes;
    case BinaryDiv;
    case BinaryRem;
    case BinaryEq;
    case BinaryNeq;
    case BinaryCeq;
    case BinaryCne;
    case BinaryWildeq;
    case BinaryWildneq;
    case BinaryLogand;
    case BinaryLogor;
    case BinaryPower;
    case BinaryLt;
    case BinaryLte;
    case BinaryGt;
    case BinaryGte;
    case BinaryBitand;
    case BinaryBitor;
    case BinaryXor;
    case BinaryXnor;
    case BinaryShr;
    case BinaryShl;
    case BinaryAshr;
    case BinaryAshl;
    case BinaryAssign;
    case BinaryPlusAssign;
    case BinaryMinusAssign;
    case BinaryTimesAssign;
    case BinaryDivAssign;
    case BinaryRemAssign;
    case BinaryAndAssign;
    case BinaryOrAssign;
    case BinaryXorAssign;
    case BinaryShlAssign;
    case BinaryShrAssign;
    case BinaryAshlAssign;
    case BinaryAshrAssign;
    case BinaryImplies;
    case BinaryEquiv;

    func str() -> String
    {
        switch(self)
        {
            case .BinaryPlus: return "+";
            case .BinaryMinus: return "-";
            case .BinaryTimes: return "*";
            case .BinaryDiv: return "/";
            case .BinaryRem: return "%";
            case .BinaryEq: return "==";
            case .BinaryNeq: return "!=";
            case .BinaryCeq: return "===";
            case .BinaryCne: return "!==";
            case .BinaryWildeq: return "==?";
            case .BinaryWildneq: return "!=?";
            case .BinaryLogand: return "&&";
            case .BinaryLogor: return "||";
            case .BinaryPower: return "**";
            case .BinaryLt: return "<";
            case .BinaryLte: return "<=";
            case .BinaryGt: return ">";
            case .BinaryGte: return ">=";
            case .BinaryBitand: return "&";
            case .BinaryBitor: return "|";
            case .BinaryXor: return "^";
            case .BinaryXnor: return "~^";
            case .BinaryShr: return ">>";
            case .BinaryShl: return "<<";
            case .BinaryAshr: return ">>>";
            case .BinaryAshl: return "<<<";
            case .BinaryAssign: return "=";
            case .BinaryPlusAssign: return "+=";
            case .BinaryMinusAssign: return "-=";
            case .BinaryTimesAssign: return "*=";
            case .BinaryDivAssign: return "/=";
            case .BinaryRemAssign: return "%=";
            case .BinaryAndAssign: return "&=";
            case .BinaryOrAssign: return "|=";
            case .BinaryXorAssign: return "^=";
            case .BinaryShlAssign: return "<<=";
            case .BinaryShrAssign: return ">>=";
            case .BinaryAshlAssign: return "<<<=";
            case .BinaryAshrAssign: return ">>>=";
            case .BinaryImplies: return "->";
            case .BinaryEquiv: return "<->";
        }
    }
}

