//
//  FolderViewModel.swift
//  Gnotes
//
//  Created by Gautham Ilango on 10/04/17.
//  Copyright © 2017 Gautham Ilango. All rights reserved.
//

import Foundation

class FolderViewModel : ViewModelProtocol {
  var folder: Folder
  
  var title: String {
    get {
    return folder.title ?? ""
    }
    
    set {
      folder.title = newValue
    }
  }
  
  var notesCount: Int {
    return folder.notes?.count ?? 0
  }
  
  init(folder: Folder) {
    self.folder = folder
  }
  
}
