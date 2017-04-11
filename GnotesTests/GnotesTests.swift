//
//  GnotesTests.swift
//  GnotesTests
//
//  Created by Gautham Ilango on 10/04/17.
//  Copyright © 2017 Gautham Ilango. All rights reserved.
//

import XCTest
@testable import Gnotes

class GnotesTests: XCTestCase {
  
   var coreDataStack: CoreDataStack!
		
    override func setUp() {
        super.setUp()
      coreDataStack = CoreDataStack.shared
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
      coreDataStack = nil
        super.tearDown()
    }
    
  func testCreationDateOfFolder() {
    let folder = Folder(context: coreDataStack.mainContext)
    let expectation = XCTestExpectation(description: "Folder's Created Date assigned")
    if folder.createdDate != nil {
      expectation.fulfill()
    }
  }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
