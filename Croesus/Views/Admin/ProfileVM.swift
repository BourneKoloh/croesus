//
//  ProfileVM.swift
//  Croesus
//
//  Created by Bourne K on 06/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class ProfileVM:ObservableObject {
    
    var uiImage: UIImage?{
        didSet{
            //
        }
    }
    
    var firstname = ""{
        didSet{
            
        }
    }
    var lastname = ""{
        didSet{
            
        }
    }
    var location = ""{
        didSet{
            
        }
    }
    var idNo = ""{
        didSet{
            
        }
    }
}
