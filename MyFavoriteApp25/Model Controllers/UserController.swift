//
//  UserController.swift
//  MyFavoriteApp25
//
//  Created by Hannah Hoff on 3/20/19.
//  Copyright © 2019 Hannah Hoff. All rights reserved.
//

import Foundation

class UserController {
    
    // Shared instance
    static let shared = UserController()
    private init() {}
    
    // Source of truth
    // sort of storage place
    var users: [User] = []
    
    // Base URL
    let baseUrl = URL(string: "https://favoriteapp-375c6.firebaseio.com")
    
    //Mark: - CRUD Functions
    
    // GET request (read)
    // Completion runs code afterwards (AFTER we get the data)
    func getUsers(completion: @escaping (Bool) -> Void){
        //URL
        guard var url = baseUrl else { completion(false); return }
        url.appendPathComponent("users")
        //https://favoriteapp-375c6.firebaseio.com/users
        url.appendPathExtension("json")
        //https://favoriteapp-375c6.firebaseio.com/users.json
        print(url)
        
        // URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        // DataTask + RESUME
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("💩 There was an error retrieving the data: \(error) ; \(error.localizedDescription) 💩")
                completion(false)
                return
            }
            if let response = response{
                print(response)
            }
            guard let data = data else { completion(false); return }
            let decoder = JSONDecoder()
            
            do {
                let dictionaryOfUsers = try decoder.decode([String : User].self, from: data)
                var tempUsers: [User] = []
                for(_, value) in dictionaryOfUsers {
                    tempUsers.append(value)
                }
                self.users = tempUsers
                completion(true)
                
            }catch {
                print("There was an error decoding the data: \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
            } .resume()
    }
    
    // POST request (create)
    //favApp?
    func postUser(name: String, favoriteApp: String, completion: @escaping (Bool) -> Void){
        
        //URL
        guard var url = baseUrl else { completion(false); return }
        url.appendPathComponent("users")
        url.appendPathExtension("json")
        
        //Request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let newUser = User(name: name, favoriteApp: favoriteApp)
        
        // Encoding
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(newUser)
            request.httpBody = data
        }catch{
            print("There was an error encoding the user into JSON: \(error) \(error.localizedDescription)")
            completion(false)
            return
        }
        // DataTask + Resume
        let dataTask = URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("There was an error POSTing the data: \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
            self.users.append(newUser)
            completion(true)
        }
        dataTask.resume()
    }
}


