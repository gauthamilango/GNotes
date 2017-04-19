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
  
  var appModel: AppModel!
		
  override func setUp() {
    super.setUp()
    appModel = AppModel.shared
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    appModel = nil
    super.tearDown()
  }
  
  func testCreationDateOfFolder() {
    if let folder = appModel.createFolder(with: "Test Folder") {
      let expectation = XCTestExpectation(description: "Folder's Creation Date assigned")
      if folder.createdDate != nil {
        expectation.fulfill()
      }
    }
  }
  
  func testDeletionOfFolder() {
    if let folder = appModel.createFolder(with: "Test Folder") {
      let expectation = XCTestExpectation(description: "Folder Deletion")
      if appModel.delete(folderViewModels: [FolderViewModel(folder: folder)]) {
        expectation.fulfill()
      }
    }
  }
  
  func testUpdationOfFolder() {
    if let folder = appModel.createFolder(with: "Test Folder") {
      let expectation = XCTestExpectation(description: "Folder Title Updation")
      let folderViewModel = FolderViewModel(folder: folder)
      if appModel.update(folderViewModel: folderViewModel, with: "Updated Test Folder Title"), folder.title ==  "Updated Test Folder Title"{
        expectation.fulfill()
      }
    }
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
