//
//  ResultsView.swift
//  HelloWorldApplication
//
//  Created by Ayaz Nakhuda on 2020-08-06.
//  Copyright © 2020 Ayaz Nakhuda. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


// Making a noew View object named LoadingScreen?
struct ResultsScreen: View {
    
    //@ObservedObject var model = WebServicesViewModel()
    
    //@ObservedObject var fetch2: WebServices = WebServices()
    @EnvironmentObject private var fetch: WebServices
    var body: some View {
        //List(model.data) { data in
          //  Text(data.name)
        //}
        VStack {
            
            
            
            //Text("\(fetch.first.name)")
            //wait 3 seconds with a spinning logo
            // then display the sorry no results or display the images
            //use a data base and store previous addresses searched
            
            // this view will be the view that will be shown when the user clicks on more info
            
            //wait until retrieveTrailData is finished
            
            //wait 3 seconds with a spinning logo
            // then display the sorry no results or display the images
            //use a data base and store previous addresses searched
            
            //just figure out how to display the images and the text
            
            //add apdding after displaying text
            
            
            List(self.fetch.trails) { ResponseFromTrailAPI in
                VStack(alignment: .leading) {
                    
                    Text("Name: \(ResponseFromTrailAPI.name)")
                    Text("Location: \(ResponseFromTrailAPI.location)")
                    Text("Acent: \(ResponseFromTrailAPI.ascent)")
                    Text("Descent: \(ResponseFromTrailAPI.descent)")
                    Text("Summary: \(ResponseFromTrailAPI.summary)")
                        .font(.system(size: 11))
                        .foregroundColor(Color.gray)
                }
            }
            
        }
            
    }
}
    
    





