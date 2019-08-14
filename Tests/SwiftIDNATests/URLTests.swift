import Foundation
import XCTest
@testable import SwiftIDNA

@available(OSX 10.15, *)
final class IDNURL: XCTestCase {
    func testURL1() {
        let input = "http://räksmörgås.josefsson.org"
        let expected = "http://xn--rksmrgs-5wao1o.josefsson.org"
        let url = URL(idnString: input)!
        XCTAssertEqual(expected, url.absoluteString)
    }
    
    func testURL2() {
        let input = "http://納豆\u{3002}w3\u{ff0e}mag\u{ff61}keio.ac.jp#fragment"
        let expected = "http://xn--99zt52a.w3.mag.keio.ac.jp#fragment"
        let url = URL(idnString: input)!
        XCTAssertEqual(expected, url.absoluteString)
    }
    
    func testURL3() {
        let input = "http://äöüß.com?query=foo"
        let expected = "http://xn--ss-uia6e4a.com?query=foo"
        let url = URL(idnString: input)!
        XCTAssertEqual(expected, url.absoluteString)
    }
    
    func testURL4() {
        let input = "http://visegrád.com/path"
        let expected = "http://xn--visegrd-mwa.com/path"
        let url = URL(idnString: input)!
        XCTAssertEqual(expected, url.absoluteString)
    }
    
    func testURL5() {
        let input = "http://házipatika.com/"
        let expected = "http://xn--hzipatika-01a.com/"
        let url = URL(idnString: input)!
        XCTAssertEqual(expected, url.absoluteString)
    }
    
    func testURL6() {
        let input = "http://айкидо.com/"
        let expected = "http://xn--80aildf0a.com/"
        let url = URL(idnString: input)!
        XCTAssertEqual(expected, url.absoluteString)
    }
}
