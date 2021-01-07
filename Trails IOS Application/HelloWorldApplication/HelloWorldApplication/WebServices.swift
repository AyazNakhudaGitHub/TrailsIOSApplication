//
//  WebServices.swift
//  HelloWorldApplication
//
//  Created by Ayaz Nakhuda on 2020-08-11.
//  Copyright © 2020 Ayaz Nakhuda. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class WebServices: ObservableObject{
    
    //@State var latitude : Double = 0.0
    //@State var longitude : Double = 0.0
    //@Published var booleanValue = false
    @Published var trails = [ResponseFromTrailAPI]()
    func retrieveAddress(address: String)//encode the address and send to API
    {
        
        
    
        //The API work will be done in the function that gets called after the user clicks on the enter button

        let headers = [
            "x-rapidapi-host": "opencage-geocoder.p.rapidapi.com",
            "x-rapidapi-key": "ccaab1808cmsh30bcb2064c80bbep1459e3jsn9abc4de81949"
        ]

        
        /*
         
         The as keyword is used for casting an object as another type of object. For this to work, the class must be convertible to that type.

         For example, this works:

         let myInt: Int = 0.5 as Int // Double is convertible to Int
         
         link to info:
            
            - https://stackoverflow.com/questions/27954516/what-function-does-as-in-the-swift-syntax-have

         */
        
        //REMEMBER TO URL ENCODE ADDRESS
        //let encryptedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as String
        //print(encryptedAddress)
        // Documentation provided by opcage Geocode API says to encrypt the q component of the URL but it seems to work well wihtout encrypting
        
        
        let queryItems = [URLQueryItem(name: "language", value: "en"), URLQueryItem(name: "key", value: "28125bfb86094d5aaac0f014a53cbbc4"), URLQueryItem(name: "q", value: address)]
        var urlComps = URLComponents(string: "https://opencage-geocoder.p.rapidapi.com/geocode/v1/json")!
        // Note that the above url is the stuff that comes before the "?" mark in the whole URL
        urlComps.queryItems = queryItems
        let result = urlComps.url!
        let urlString = result.absoluteString // turn the newly made url above into a string and then use it below
        //print(urlString) -> used for checking the URL
        //get the url then use it in the request
        
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        
        
        /*
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://opencage-geocoder.p.rapidapi.com/geocode/v1/json?language=en&key=28125bfb86094d5aaac0f014a53cbbc4&q=32%20Kennedy%20Road%20North")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        */
        
        //Use "GET" to retrieve data, use "POST" to submit data
        request.httpMethod = "GET"
        
        
        request.allHTTPHeaderFields = headers
        
        // Specify the body
        
        //let jsonBody = [] as [String:Any]

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        
        // Completion handler is a function that will capture the response from the API
        // data, response and error are optional parameters and are apart of the completionHandler?
        // perhaps Void means that the function completionHandler can take in any object
        // the "in" keyword means that the line below is going to be the start of the closure.
            
            if (error != nil && data != nil) {
                
                print("Error")
                
            }
            else {
                let httpResponse = response as? HTTPURLResponse
                //try to parse out the data (which is a dictionary) recieved in the completion handler we can use ! with data because we had already checked to see if it is empty
                
                /*
                 
                 Note on the use of the exclamation mark:
                 
                  Swift uses exclamation marks to signal both force unwrapping of optionals and explicitly unwrapped optionals. The former means "I know this optional variable definitely has a value, so let me use it directly." The latter means "this variable is going to be nil initially then will definitely have a value afterwards, so don't make me keep unwrapping it."
                 
                 -from https://www.hackingwithswift.com/example-code/language/what-does-an-exclamation-mark-mean
                 
                 so by using data! in the later lines, I am telling the compiler that "hey, this for sure is not going to give problems becasue I have already checked to see if data is empty
                 
                 */
                
                do {
                    //let dictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any]
                    //UNDERSTAND WHAT THIS LINE DOES!!!! keep this line around for the reference copy
                    //print("---------------------------------------------------------------------")
                    //print(dictionary)
                    //print("---------------------------------------------------------------------")
                    //parse the JSON data and learn how to model the response JSON data from the OpenCage geocode API
                    
                  // Debated on putting the structs below in their own file but went against it becasue it's easier to understand the structure of the data.
                    
                    
                    /*
                    struct BlockResponse: Codable { //This is the root struct
                        
                        
                        let results: [Block]
                        
                    }
                    
                    struct Block: Codable {
                        
                        let confidence: Int
                        let geometry: Geometrics
                        
                    }
                    
                    struct Geometrics: Codable {
                        
                        let lat: Double
                        let lng: Double
                        
                    }
                     
                    
                         
                    */
                    
                    let responseDecoder = JSONDecoder()
                    
                    do {
                        
                        let extractedData = try responseDecoder.decode(BlockResponse.self, from: data!)
                        //UNDERSTAND WHAT THIS LINE DOES!
                        
                        
                        //unknown context seems to be a problem but I am able to extract the data I need I just need to clean up the data and finally get the latitude and longitude of the result with the highest confidence
                        
                        
                        print("---------------------------------------------------------------------")
                        //print(extractedData.results)
                        
                        var dictionaryOfConfidenceToGeometrics = [Int:Geometrics]()
                        for Block in extractedData.results
                        {
                            
                            /*
                             Dict.updateValue updates value for existing key from dictionary or adds new new key-value pair if key does not exists.
                             -stackoverflow: https://stackoverflow.com/questions/27313242/how-to-append-elements-into-a-dictionary-in-swift
                             
                             */
                            //the key is the confidence value
                            //if the dictionary is empty add the key value pair,
                            //if the dictionary is not empty then compare the new key to the old and
                            //if the new key is greater or equal then add the new pair and remove the old
                            //do nothing if the new key is less than the old
                            
                            if dictionaryOfConfidenceToGeometrics.count == 0
                            {
                                dictionaryOfConfidenceToGeometrics.updateValue(Block.geometry as Geometrics, forKey: Block.confidence)
                            }
                            
                            else if dictionaryOfConfidenceToGeometrics.first!.key <= Block.confidence{
                                
                                dictionaryOfConfidenceToGeometrics.removeValue(forKey: dictionaryOfConfidenceToGeometrics.first!.key)
                                
                                dictionaryOfConfidenceToGeometrics.updateValue(Block.geometry as Geometrics, forKey: Block.confidence)
                                
                            }
                            
                            else {
                                
                                break
                            }
                            //print(Block.confidence)
                            //print(Block.geometry)
                            //now instead of printing add objects to the array list or dictionary
                        }
                        //print(dictionaryOfConfidenceToGeometrics)
                        let latitude: Double = (dictionaryOfConfidenceToGeometrics.first?.value.lat)!
                        let longitude: Double = (dictionaryOfConfidenceToGeometrics.first?.value.lng)!
                        print(latitude)
                        print(longitude)
                        //var max: Int = 0
                        //for (Int, Geometrics) in dictionaryOfConfidenceToGeometrics {
                          //if
                        self.retrieveTrail(lat: latitude, lng: longitude)
                        //self.retrieveTrail()
                        
                        // BlockResponse -> Block (but problem here bec of array ->
                        //test using printing but make a variable or array that will hold all these values and access them using this inheritance model
                        //print("---------------------------------------------------------------------")
                        
                        
                        
                        //now just find the key with the highest confidence and use inheritance to extract nice clean lat and lng values
                    }
                        
                    catch {
                        
                        print("Error parsing the JSON body. \(error.localizedDescription)")
                        print("---------------------------------------------------------------------")
                        //return nil
                    }
                    
                    
                    
                    
                }
                    
        
            }
        })

        dataTask.resume()
        print("This is the address \(address)")
    
    }
   
    
    func retrieveTrail(lat: Double, lng: Double) {
        
        
        
        let queryItems = [URLQueryItem(name: "lat", value: String(lat)), URLQueryItem(name: "lon", value: String(lng)), URLQueryItem(name: "key", value: "200846496-fc96b47c269fe586ea18ecfb4e657810")]
        var urlComps = URLComponents(string: "https://www.hikingproject.com/data/get-trails")!
        
        urlComps.queryItems = queryItems
        let result = urlComps.url!
        let urlString = result.absoluteString
        
       
        
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        
        
        let session = URLSession.shared
               let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
               
                   
                   if (error != nil && data != nil) {
                       
                       print("Error")
                       
                   }
                   else {
                    
                    //let httpResponse = response as? HTTPURLResponse
                    
                    do {
                        
                        let dictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any]
                        
                        print("---------------------------------------------------------------------")
                        print(dictionary)
                        print("---------------------------------------------------------------------")
                        
                        //model the data and make a dictionary and somehow give that dictionary to the ResultsScreen
                    /*
                        struct ListOfResponseFromTrailAPI: Codable {
                            
                            let trails: [ResponseFromTrailAPI]
                        }
                    
                        struct ResponseFromTrailAPI: Codable {
                            
                            let name: String
                            let location: String
                            let ascent: Int
                            let descent: Int
                            let summary: String
                            let imgSqSmall: String
                        }
                    
                        */
                        
                        let responseDecoder2 = JSONDecoder()
                        
                        do {
                            
                            let extractedData2 = try responseDecoder2.decode(ListOfResponseFromTrailAPI.self, from: data!)
                            self.trails = extractedData2.trails
                            //self.booleanValue = true
                            //print("Hello")
                            //print(self.trails)
                            //print("Hello")
                            //self.$trails = extractedData2.trails
                            //print(self.trails)
                            var DictionaryOfContents = [String:Any]()
                            var i:Int = 0
                            var dictionaryOfTrails = [Int:Any]()
                            for ResponseFromTrailAPI in extractedData2.trails {
                                
                                //self.settings.Name = ResponseFromTrailAPI.name
                                DictionaryOfContents.updateValue(ResponseFromTrailAPI.name, forKey: "Name")
                                DictionaryOfContents.updateValue(ResponseFromTrailAPI.location, forKey: "Location" )
                                DictionaryOfContents.updateValue(ResponseFromTrailAPI.ascent, forKey: "Ascent")
                                DictionaryOfContents.updateValue(ResponseFromTrailAPI.descent, forKey: "Descent")
                                DictionaryOfContents.updateValue(ResponseFromTrailAPI.summary, forKey: "Summary" )
                                DictionaryOfContents.updateValue(ResponseFromTrailAPI.imgSqSmall, forKey:  "imgSqSmall")
                                
                                dictionaryOfTrails.updateValue(DictionaryOfContents, forKey: i)
                                i+=1
                                
                                //DictionaryOfContents.removeAll()
                                
                            }
                            
                            //self.settings.dictOfValuesToShare = dictionaryOfTrails
                            //print(dictionaryOfTrails)
                            /* Useful notes:
                            
                            @Published is one of the most useful property wrappers in SwiftUI, allowing us to create observable objects that automatically announce when changes occur. SwiftUI will automatically monitor for such changes, and re-invoke the body property of any views that rely on the data. -https://www.hackingwithswift.com/quick-start/swiftui/what-is-the-published-property-wrapper
                            
                             perhaps add this to the dictionary within another dictionary and send it to the other view to be displayed
                             
                             this way we can extablish a hiearchy and use inheritance to easily access the data
                            
                             
                             instead of using dictionaries use the published property to directly affect the results view
                             
                             have the function return something and then since the function was called in a view just have the value returned be sent to the other view
                            */
                            
                            for i in 0...dictionaryOfTrails.capacity  {
                                
                                print(dictionaryOfTrails[i])
                                
                                print("---------------------------------------------------------------------")
                                
                            }
                            
                        
                        
                        
                        }
                        
                        catch {
                            
                            print("Error parsing the data  \(error.localizedDescription)")
                            
                        }
                            
                            
                    }
                    catch {
                        
                        print("Error parsing the data  \(error.localizedDescription)")
                        
                    }
                    
                }
            })
        
            dataTask.resume()
        
        
    }
    
    
    
}


