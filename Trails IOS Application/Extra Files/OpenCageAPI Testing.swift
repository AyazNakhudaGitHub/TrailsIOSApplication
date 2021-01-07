//
//  AppDelegate.swift
//  HelloWorldApplication
//
//  Created by Ayaz Nakhuda on 2020-05-30.
//  Copyright © 2020 Ayaz Nakhuda. All rights reserved.
//



class ViewController : UIViewController
{
    /* For now I'm going to assume that the UIViewController is something inside the UIKit library and that I am just letting the compiler know that the class named ViewController is going to be working with UIViewController
    */
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // I assume we are calling a super class but we have to figure out what this does
        
        //Note again, we could use the IOS SDK but since this is my first time, I'd like to take the time and understand the process and do the work manually.
        
        // Do any additional setup after loading the view
        
        // URL --> is this URL the "endpoint"
        let url = URL(string: "https://opencage-geocoder.p.rapidapi.com/geocode/v1/json?language=en&key=OPENCAGE-API-Key&q=Berlin")
        
        //this url could be nil so do the following:
        
        guard url != nil else //this line is saying if url is nil then execute the print statement
        {
            
            print("Error in creating url")
            return
            
            /*
             
             you have to use break or return to get out of the guard condition; so after the return statment, you exit the viewDidLoad() function and any code after this function will be executed otherwise if there is no further code, the program will stop executing.
 
            */
            
        }
        
        /*
         In Objective-C, nil is a pointer to a non-existent object. In Swift, nil is not a pointer—it is the absence of a value of a certain type. Optionals of any type can be set to nil , not just object types. NULL has no equivalent in Swift. nil is also called nil in Swift.
         
         */
        
        // URL request --> this will have to be modified thus we use var
        
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        /* when we do url! we are force unwrapping it because we already checked that it is not nil look more into this!
        
        */
        
        
        // Specify the header;  this is our dictionary
        let headers = ["x-rapidapi-host": "opencage-geocoder.p.rapidapi.com",
        "x-rapidapi-key": "ccaab1808cmsh30bcb2064c80bbep1459e3jsn9abc4de81949"]
        
        
        
        //request.addValue(<#T##value: String##String#>, forHTTPHeaderField: <#T##String#>)
        
        request.allHTTPHeaderFields = headers // -> look into what this means
        // perhaps what happens in this line is that since request is of the type URLRequest??? perhaps in this class there is an instance variable called allHTTPHeaderFields where we set the value of this instance variable of this particular instance of this class [allHTTPHeaderFields] here but, in other programming languages such as Java you'd would need a "setter" method or a method that when called can change the value of instance variables of other classes after instantiation.
        
        // Specify the body --> not sure if you need this!
        
        let jsonObject = ["key" :"OPENCAGE-API-Key: 28125bfb86094d5aaac0f014a53cbbc4", "q" : "Berlin"] as [String:Any]
        
        do
        {
       
            let requestBody = try JSONSerialization.data(withJSONObject: jsonObject, options: .fragmentsAllowed)
            
            request.httpBody = requestBody
         }
        
        catch
        {
            print("Error creating the data from json")
        }
        
        
        // Set the request type
        //"POST" is for submitting data while "GET" is for getting data
        
        request.httpMethod = "GET"
        
        // Get the URLSession
        
        let session = URLSession.shared
        
        // Create the data task; here we specify our request that request being our URL. We can also specify a completion handler which will capture the response from the API.
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
        // Using a void * means that the function can take a pointer that doesn't need to be a specific type - Quote retrieved from StackOverFlow
        //So because in this case I used -> before Void, that means that the returned value from this function can be anything?
            
        
        //there is a closure above data, repsonse and error are optional parameters
            
        //check for errors
            print("okay")
            if error == nil && data != nil // so if there is no value associated with error and there is data
            {
                do
                {
                    
                let dictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any]
                    print("okay")
                    print(dictionary)
                }
                
                catch
                {
                    print("Error parsing response data")
                }
            }
            
        
        }
        dataTask.resume() //this fires off the data task
        
        
        // Fire off the data task --> essentailly making the API call
        
        
        //remember to change the value of q
        
        
        
    }
    
}
