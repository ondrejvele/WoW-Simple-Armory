//
//  ArmoryController.swift
//  WoW Simple Armory
//
//  Created by Ondřej Vele on 18.01.2021.
//

import Foundation

protocol ArmoryManagerDelegate {
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
    
    //MARK: - Perform Request
    
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
                    if let armory = parseJSON(armoryData: safeData) {
                        delegate?.didUpdateArmory(self, armory: armory)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    
    //MARK: - parseJSON
    
    func parseJSON(armoryData: Data) -> armoryModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ArmoryData.self, from: armoryData)
            print("Decoded data: Race: \(decodedData.race), Class: \(decodedData.class), Spec: \(decodedData.active_spec_name), Faction: \(decodedData.faction)")
            
            let armory = armoryModel(
                raceName: decodedData.race,
                className: decodedData.class,
                specName: decodedData.active_spec_name,
                factionName: decodedData.faction
            )
            return armory
        } catch {
            print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
