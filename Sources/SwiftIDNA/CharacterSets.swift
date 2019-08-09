import Foundation

extension Unicode {
    /// ASCII characters that are not letters, digits, or hyphen (LDH).
    ///
    /// Specified in [RFC 1034](https://tools.ietf.org/rfc/rfc1034.txt) and [RFC 1035](https://tools.ietf.org/rfc/rfc1035.txt).
    public static let prohibitedBySTD3ASCII = CharacterSet([ UnicodeScalar(0x00)!, UnicodeScalar(0x01)!, UnicodeScalar(0x02)!, UnicodeScalar(0x03)!, UnicodeScalar(0x04)!, UnicodeScalar(0x05)!, UnicodeScalar(0x06)!, UnicodeScalar(0x07)!, UnicodeScalar(0x08)!, UnicodeScalar(0x09)!, UnicodeScalar(0x0a)!, UnicodeScalar(0x0b)!, UnicodeScalar(0x0c)!, UnicodeScalar(0x0d)!, UnicodeScalar(0x0e)!, UnicodeScalar(0x0f)!, UnicodeScalar(0x10)!, UnicodeScalar(0x11)!, UnicodeScalar(0x12)!, UnicodeScalar(0x13)!, UnicodeScalar(0x14)!, UnicodeScalar(0x15)!, UnicodeScalar(0x16)!, UnicodeScalar(0x17)!, UnicodeScalar(0x18)!, UnicodeScalar(0x19)!, UnicodeScalar(0x1a)!, UnicodeScalar(0x1b)!, UnicodeScalar(0x1c)!, UnicodeScalar(0x1d)!, UnicodeScalar(0x1e)!, UnicodeScalar(0x1f)!, UnicodeScalar(0x20)!, UnicodeScalar(0x21)!, UnicodeScalar(0x22)!, UnicodeScalar(0x23)!, UnicodeScalar(0x24)!, UnicodeScalar(0x25)!, UnicodeScalar(0x26)!, UnicodeScalar(0x27)!, UnicodeScalar(0x28)!, UnicodeScalar(0x29)!, UnicodeScalar(0x2a)!, UnicodeScalar(0x2b)!, UnicodeScalar(0x2c)!, UnicodeScalar(0x2e)!, UnicodeScalar(0x2f)!, UnicodeScalar(0x3a)!, UnicodeScalar(0x3b)!, UnicodeScalar(0x3c)!, UnicodeScalar(0x3d)!, UnicodeScalar(0x3e)!, UnicodeScalar(0x3f)!, UnicodeScalar(0x40)!, UnicodeScalar(0x5b)!, UnicodeScalar(0x5c)!, UnicodeScalar(0x5d)!, UnicodeScalar(0x5e)!, UnicodeScalar(0x5f)!, UnicodeScalar(0x60)!, UnicodeScalar(0x7b)!, UnicodeScalar(0x7c)!, UnicodeScalar(0x7d)!, UnicodeScalar(0x7e)!, UnicodeScalar(0x7f)! ])
}
