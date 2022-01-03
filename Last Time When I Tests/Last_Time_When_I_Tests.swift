//
//  Last_Time_When_I_Tests.swift
//  Last Time When I Tests
//
//  Created by Zhihao Cui on 03/01/2022.
//  Copyright © 2022 zhihaocui. All rights reserved.
//

import XCTest
@testable import Last_Time

class Last_Time_When_I_Tests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEventFormattedString() throws {
        let context = PersistenceController.preview.container.viewContext
        let event = Event.init(context: context)
        event.timestamp = Date().addingTimeInterval(-15000)
        
        XCTAssertEqual(event.wrappedTimestamp.relativeToNow(), "4 hours ago")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
