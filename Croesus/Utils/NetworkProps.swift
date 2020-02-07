//
//  NetworkConstants.swift
//  Croesus
//
//  Created by Bourne K on 06/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import Foundation

struct NetworkProps {
       static var connectivity: Connectivity!
       enum Status: String {
           case unreachable, wwan, wifi
         
       }
       enum Error: Swift.Error {
           case failedToSetCallout
           case failedToSetDispatchQueue
           case failedToCreateWith(String)
           case failedToInitializeWith(sockaddr_in)
       }
   }
