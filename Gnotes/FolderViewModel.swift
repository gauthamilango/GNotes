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
    return folder.title ?? ""
  }
  
  init(folder: Folder) {
    self.folder = folder
  }
  
}
