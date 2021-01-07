//
//  ContentView.swift
//  HelloWorldApplication
//
//  Created by Ayaz Nakhuda on 2020-05-30.
//  Copyright © 2020 Ayaz Nakhuda. All rights reserved.
//


import Foundation
import SwiftUI
import Combine


struct ContentView: View {
    
    @State private var address: String = ""
    @State private var isActive = false
    @ObservedObject var fetch: WebServices = WebServices()
    
    //State means that this variable changes
    
    
    
    /*
     
    SwiftUI manages the storage of any property you declare as a state. When the state value changes, the view invalidates its appearance and recomputes the body. Use the state as the single source of truth for a given view. A State instance isn't the value itself; it's a means of reading and writing the value.
     
                    -Source developer.apple.com
    
     SwiftUI uses the @State property wrapper to allow us to modify values inside a struct, which would normally not be allowed because structs are value types. When we put @State before a property, we effectively move its storage out from our struct and into shared storage managed by SwiftUI. This means SwiftUI can destroy and recreate our struct whenever needed (and this can happen a lot!), without losing the state it was storing.
                    
                    -Source
                        hackingwithswift.com
    
    */
    
    var body: some View {
        NavigationView{
            //NavigationLink will present new screens when the user interacts with their contents
            VStack {
                
                
                
                Text("Hello, Welcome!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding()
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                
                Text("Please enter your address")
                    .padding(.top)
                
                TextField("", text: $address)
                //use the $ prefix to access a binding to a state variable, or one of its properties.
                    .padding()
                    .frame(width: 203.0)
                .border(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/, width: 2)
                    .cornerRadius(/*@START_MENU_TOKEN@*/4.0/*@END_MENU_TOKEN@*/)
                
                NavigationLink(destination: ResultsScreen().environmentObject(fetch), isActive: $isActive) {
                    //I sent fetch into a sub view as an envriomental object
                    //Inside these braces contains the contents where if intereacted by the user, the link will be accessed and the new view will pop up on the user's screen
                    
                    Button(action: {
                                    //WebServices().retrieveAddress(address: self.address)
                        self.retreiveAddress(adrs: self.address)
                        
                        //wait until the function above is done? because it takes time to get the data and have trails get assigned values
                        self.isActive = true
                                    // This is worriesome because it seems like we are working with a class without making an object
                                    //in swift classes are reference types meaning if you make two copies of a class then both of these classes are refrences to the ONE instance of the class
                                    //whereas for structs if you made a copy, the two stucts will be two unique instances. In other words, you will have two objects that may appear to be the same but are two different instances of the same class -> in terms of java object oriented programming
                                    
                    }) {
                        //this is a closure it allows me to execute as many functions when this button is clicked
                    
                    Text("Enter")
                        .foregroundColor(Color.white)
                        .frame(width: 52.0, height: 24.0)
                        .background(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/)
                        .cornerRadius(/*@START_MENU_TOKEN@*/9.0/*@END_MENU_TOKEN@*/)
                    }
                     // Since all of these components are in a vertical stack, I had to put this button + NavigationLink at the bottom to have it at the bottom
                    
                    
                }
                
                
                
                
            
            }
        //vstack stannds for vertical stacks and I belive that it allows for text fields to be plaved one ontop of another text field.
            
            
        }
        
    }
    func retreiveAddress(adrs: String) {
        fetch.retrieveAddress(address: adrs)
    }

    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

