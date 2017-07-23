//
//  Zalora_TestingTests.swift
//  Zalora TestingTests
//
//  Created by Jack on 7/22/17.
//  Copyright © 2017 Htuinngh. All rights reserved.
//

import XCTest
@testable import Zalora_Testing

class Zalora_TestingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSplitStringResultCount() {
        
        // Sorry, I dont have exp for unit test
        let inputString = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself.I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself.I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself.I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself.I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself.I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself.I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself.I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself.I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        let messages = inputString.splitByLength(Config.limitedLength)
        
        XCTAssertEqual(messages.count, 20, "Split message get wrong result")
        
        for message in messages {
            
            XCTAssertLessThanOrEqual(message.characters.count, Config.limitedLength, "Split message get wrong expect result")
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
