//
//  APIController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/9/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit


class APIController {
    
    static let shared = APIController()
    
    func getUserResponses(userId: Int, completion: @escaping ([Response]?, Error?) -> Void) {
        let url = baseUrl.appendingPathComponent("users")
                         .appendingPathComponent("\(userId)")
                         .appendingPathComponent("responses")
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error with getting user responses: \(error)")
                completion(nil, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                completion(nil, error)
                return
            }
            
            
            guard let data = data else {
                NSLog("Error retrieving data: \(error)")
                completion(nil, error)
                return
            }
            
            do {
                let responses = try JSONDecoder().decode([Response].self, from: data)
                completion(responses, nil)
            } catch {
                NSLog("Error with network request: \(error)")
                completion(nil, error)
                return
            }
            
            NSLog("Successfully fetched all User Responses")
            
            
        }.resume()
    }
    
    func getTeamMembers(teamId: Int, completion: @escaping ([User]?, Error?) -> Void) {
        let url = baseUrl.appendingPathComponent("teams")
            .appendingPathComponent("\(teamId)")
            .appendingPathComponent("users")
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error with getting team members: \(error)")
                completion(nil, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                completion(nil, error)
                return
            }
            
            
            guard let data = data else {
                NSLog("Error retrieving data: \(error)")
                completion(nil, error)
                return
            }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(users, nil)
            } catch {
                NSLog("Error with network request: \(error)")
                completion(nil, error)
                return
            }
            
            NSLog("Successfully fetched Team members")
            
            
            }.resume()
    }
    
    func getManagingTeam(userId: Int, completion: @escaping (Team?, Error?) -> Void) {
        let url = baseUrl.appendingPathComponent("users")
            .appendingPathComponent("\(userId)")
            .appendingPathComponent("teams")
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error with getting user team: \(error)")
                completion(nil, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                completion(nil, error)
                return
            }
            
            
            guard let data = data else {
                NSLog("Error retrieving data: \(error)")
                completion(nil, error)
                return
            }
            
            do {
                let team = try JSONDecoder().decode([Team].self, from: data).first
                completion(team, nil)
            } catch {
                NSLog("Error with network request: \(error)")
                completion(nil, error)
                return
            }
            
            NSLog("Successfully fetched User Team")
            
            
            }.resume()
    }
    
    func sendSurveyNotification() {
        //This will be inside
        let emojis = ["😄","😃"]
        localNotificationHelper.getAuthorizationStatus { (status) in
            switch status {
            case .authorized:
                self.localNotificationHelper.sendSurveyNotification(emojis: emojis, schedule: "Daily")
            case .notDetermined:
                self.localNotificationHelper.requestAuthorization(completion: { (granted) in
                    
                    if (granted) {
                        self.localNotificationHelper.sendSurveyNotification(emojis: emojis, schedule: "Daily")
                    }
                })
            default:
                return
            }
        }
    }
    
    //Get Image
    private func getImage(url: URL, completion: @escaping (UIImage?, Error?) -> Void = {_,_ in}) {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                NSLog("Error returning image: \(error)")
                completion(nil, error)
                return
            }
            let image = UIImage(data: data)
            completion(image, error);
            }.resume()
    }
    
    
    
    
    let localNotificationHelper = LocalNotificationHelper()
    let baseUrl = URL(string: "http://localhost:3000/")!
}
