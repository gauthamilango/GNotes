//
//  AppModel.swift
//  Gnotes
//
//  Created by Gautham Ilango on 19/04/17.
//  Copyright © 2017 Gautham Ilango. All rights reserved.
//

import Foundation
import CoreData
import BNRCoreDataStack

class AppModel {
  
  static let shared = AppModel()
  lazy var coreDataStack = CoreDataStack.shared
  
  
  /// Fetches all folders, sorts it based on creation date in descending order and returns as FolderViewModel array
  ///
  /// - Returns: Array of FolderViewModels
  func fetchAllFolders() -> [FolderViewModel] {
    
    do {
      let folders = try Folder.allInContext(coreDataStack.mainContext)
        .sorted { (folderOne, folderTwo) -> Bool in
          return folderOne.createdDate?.timeIntervalSince1970 ?? 0 < folderTwo.createdDate?.timeIntervalSince1970 ?? 0
        }
        .map { FolderViewModel(folder: $0) }
      
      return folders
      
    } catch {
      print(error.localizedDescription)
      return []
    }
    
  }
  
  
  /// Creates a new folder with given title, returns the new folder on successful creation
  ///
  /// - Parameter title: The Title of the new folder
  /// - Returns: New Folder on success, nil if failed
  func createFolder(with title: String) -> Folder? {
    let newFolder = Folder(context: CoreDataStack.shared.mainContext)
    newFolder.title = title
    if let _ = coreDataStack.saveContext() {
      return nil
    } else {
    return newFolder
    }
  }
  
  
  /// Deletes the folders for given folderViewModels and returns true on successful deletion
  ///
  /// - Parameter folderViewModels: The FolderViewModels of Folders needed to be deleted
  /// - Returns: True on success and false on failure
  func delete(folderViewModels: [FolderViewModel]) -> Bool {
    for folderViewModel in folderViewModels {
      coreDataStack.mainContext.delete(folderViewModel.folder)
    }
    if let _ = coreDataStack.saveContext() {
      return false
    } else {
      return true
    }
  }
  
  
  /// Updates given folderViewModel with new title and return true on successful updation
  ///
  /// - Parameters:
  ///   - folderViewModel: The FolderViewModel needed to be updated
  ///   - title: The new title
  /// - Returns: True on successfull updation and false on failure
  func update(folderViewModel: FolderViewModel, with title: String) -> Bool {
    folderViewModel.title = title
    if let _ = coreDataStack.saveContext() {
      return false
    } else {
      return true
    }
  }
  
  
}
