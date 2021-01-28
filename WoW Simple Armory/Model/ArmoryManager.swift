//
//  ArmoryController.swift
//  WoW Simple Armory
//
//  Created by Ondřej Vele on 18.01.2021.
//

import Foundation

protocol ArmoryManagerDelegate {
    //func didUpdateArmory(characterClass: String, characterRace: String, characterTalentSpec: String)
    func didUpdateArmory (_ armoryManager: ArmoryManager, armory: armoryModel)
    func didFailWithError(error: Error)
}

struct ArmoryManager {
    
    var delegate: ArmoryManagerDelegate?
    
    let regions = ["eu", "us", "tw", "kr", "cn"]
    let armoryURL = "https://raider.io/api/v1/characters/profile"
    
    func fetchArmory(region: String, realm: String, name: String) {
        let urlString = "\(armoryURL)?region=\(region)&realm=\(realm)&name=\(name)"
        performRequest(urlString: urlString)
        print(urlString)
    }
    
    func performRequest(urlString: String) {
        
        //1. create URL
        if let url = URL(string: urlString) {
            //2. create URL Session
            let session = URLSession(configuration: .default)
            //3. Give the session task
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    //let dataString = String(data: safeData, encoding: .utf8)
                    //print(dataString!)
                    if let armory = parseJSON(armoryData: safeData) {
                        delegate?.didUpdateArmory(self, armory: armory)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(armoryData: Data) -> armoryModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ArmoryData.self, from: armoryData)
            print(decodedData.race)
            print(decodedData.class)
            print(decodedData.active_spec_name)
            
            let raceName = decodedData.race
            let className = decodedData.class
            let specName = decodedData.active_spec_name
            
            let armory = armoryModel(raceName: raceName, className: className, specName: specName)
            return armory
        } catch {
            print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
