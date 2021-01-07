//
//  WebSerivcesViewModel.swift
//  HelloWorldApplication
//
//  Created by Ayaz Nakhuda on 2020-08-11.
//  Copyright © 2020 Ayaz Nakhuda. All rights reserved.
//

import Foundation
import SwiftUI
import Combine // a more reactive framework
/*
final class WebServicesViewModel: ObservableObject {
    
    init() {
        
        fetchData()
    }
    
    var data = [ResponseFromTrailAPI]() {
        
        didSet{
            didChange.send(self)
        }
        
    }
    
    private func fetchData() {
        
        WebServices().retrieveTrail  {
            self.data = $0
            
        }
        
    }
    
    let didChange = PassthroughSubject<WebServicesViewModel,Never>()
    
}

*/
