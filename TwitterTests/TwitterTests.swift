//
//  TwitterTests.swift
//  TwitterTests
//
//  Created by Phuc Nguyen on 5/11/19.
//  Copyright © 2019 Phuc Nguyen. All rights reserved.
//

import XCTest
@testable import Twitter

class TwitterTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let input = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        let expected = ["1/2 I can't believe Tweeter now supports chunking",
                        "2/2 my messages, so I don't have to do it myself."]
        
        guard let output = input.chunks() else {
            XCTFail("Message contains a span of non-whitespace characters longer than 50 characters")
            return
        }
        
        XCTAssertEqual(output.count, 2, "2 parts")
        XCTAssertEqual(output, expected, "Expected: Same the expectation from the Assignment")
    }
    
    func testCharacter() {
        let input = "a"
        let expected = ["a"]
        
        guard let output = input.chunks() else {
            XCTFail("Message is empty or contains a span of non-whitespace characters longer than 50 characters")
            return
        }
        
        XCTAssertEqual(output.count, 1, "1 part")
        XCTAssertEqual(output, expected, "Success!")
    }
    
    func testMessageContainsRedundantSpans() {
        let input = "I  can't  believe  Tweeter  now  supports  chunking  my  messages,  so  I  don't  have to  do  it  myself."
        let expected = ["1/2 I can't believe Tweeter now supports chunking",
                        "2/2 my messages, so I don't have to do it myself."]
        
        guard let output = input.chunks() else {
            XCTFail("Message contains a span of non-whitespace characters longer than 50 characters")
            return
        }
        
        XCTAssertEqual(output.count, 2, "2 parts")
        XCTAssertEqual(output, expected, "Expected: Same the expectation from the Assignment")
    }
    
    func testMessageContainsRedundantSpansAndLinebreaks() {
        let input = "I  can't  believe  Tweeter  now  supports  chunking  my  messages,\n\nso  I  don't  have to  do  it  myself."
        let expected = ["1/2 I can't believe Tweeter now supports chunking",
                        "2/2 my messages, so I don't have to do it myself."]
        
        guard let output = input.chunks() else {
            XCTFail("Message contains a span of non-whitespace characters longer than 50 characters")
            return
        }
        
        XCTAssertEqual(output.count, 2, "2 parts")
        XCTAssertEqual(output, expected, "Expected: Same the expectation from the Assignment")
    }
    
    func testFitWord() {
        let input = "abcdefghijklmnopqrstuvwxyz012345678910111213141516"
        let expected = ["abcdefghijklmnopqrstuvwxyz012345678910111213141516"]
        
        guard let output = input.chunks() else {
            XCTFail("Message is empty or contains a span of non-whitespace characters longer than 50 characters")
            return
        }
        
        XCTAssertEqual(output.count, 1, "1 part")
        XCTAssertEqual(output, expected, "Success!")
    }
    
    func testOverlongWord() {
        let input = "abcdefghijklmnopqrstuvwxyz01234567891011121314151617"
        
        let output = input.chunks()
        
        XCTAssertNil(output, "Message contains a span of non-whitespace characters longer than 50 characters")
    }
    
    func testMessageContainsOverlongWord() {
        let input = "This abcdefghijklmnopqrstuvwxyz01234567891011121314151617 word can not be chunked!"
        
        let output = input.chunks()
        
        XCTAssertNil(output, "Message contains a span of non-whitespace characters longer than 50 characters")
    }
    
    func testLongMessage() {
        let input = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself. I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself. I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself. I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself. I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself. I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself. I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself. I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself. I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself. I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself. I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself. I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself. I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself. I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself. I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        let expected = ["1/33 I can't believe Tweeter now supports chunking",
                        "2/33 my messages, so I don't have to do it myself.",
                        "3/33 I can't believe Tweeter now supports chunking",
                        "4/33 my messages, so I don't have to do it myself.",
                        "5/33 I can't believe Tweeter now supports chunking",
                        "6/33 my messages, so I don't have to do it myself.",
                        "7/33 I can't believe Tweeter now supports chunking",
                        "8/33 my messages, so I don't have to do it myself.",
                        "9/33 I can't believe Tweeter now supports chunking",
                        "10/33 my messages, so I don't have to do it",
                        "11/33 myself. I can't believe Tweeter now supports",
                        "12/33 chunking my messages, so I don't have to do",
                        "13/33 it myself. I can't believe Tweeter now",
                        "14/33 supports chunking my messages, so I don't",
                        "15/33 have to do it myself. I can't believe",
                        "16/33 Tweeter now supports chunking my messages,",
                        "17/33 so I don't have to do it myself. I can't",
                        "18/33 believe Tweeter now supports chunking my",
                        "19/33 messages, so I don't have to do it myself. I",
                        "20/33 can't believe Tweeter now supports chunking",
                        "21/33 my messages, so I don't have to do it",
                        "22/33 myself. I can't believe Tweeter now supports",
                        "23/33 chunking my messages, so I don't have to do",
                        "24/33 it myself. I can't believe Tweeter now",
                        "25/33 supports chunking my messages, so I don't",
                        "26/33 have to do it myself. I can't believe",
                        "27/33 Tweeter now supports chunking my messages,",
                        "28/33 so I don't have to do it myself. I can't",
                        "29/33 believe Tweeter now supports chunking my",
                        "30/33 messages, so I don't have to do it myself. I",
                        "31/33 can't believe Tweeter now supports chunking",
                        "32/33 my messages, so I don't have to do it",
                        "33/33 myself."
        ]
        
        guard let output = input.chunks() else {
            XCTFail("Message is empty or contains a span of non-whitespace characters longer than 50 characters")
            return
        }
        
        XCTAssertEqual(output.count, 33, "33 part")
        XCTAssertEqual(output, expected, "Success!")
    }

}
