//
//  ViewController.swift
//  WoW Simple Armory
//
//  Created by Ondřej Vele on 18.01.2021.
//

import UIKit

class InputViewController: UIViewController {
    
    var selected = ""
    
    var classResult = ""
    var raceResult = ""
    var specResult = ""
    var factionResult: UIImage?

    @IBOutlet weak var realmInput: UITextField!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var regionPicker: UIPickerView!
    
    @IBOutlet weak var factionImage: UIImageView!
    
    var armoryManager = ArmoryManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //for test purpose
        realmInput.text = "Drakthul"
        nameInput.text = "Skymonk"

        
        regionPicker.dataSource = self
        regionPicker.delegate = self
        armoryManager.delegate = self
        
        realmInput.delegate = self
        nameInput.delegate = self
        
        selected = armoryManager.regions[0]
        
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        let realmInputValue = realmInput.text!
        let nameInputValue = nameInput.text!
        let selectedRegion = selected
        
        armoryManager.fetchArmory(region: selectedRegion, realm: realmInputValue, name: nameInputValue)
        
        realmInput.endEditing(true)
        nameInput.endEditing(true)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowResult" {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.charClass = classResult
            destinationVC.charRace = raceResult
            destinationVC.charSpec = specResult
            destinationVC.charFaction = factionResult
        }
    }
}

//MARK: - Picker View

extension InputViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return armoryManager.regions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return armoryManager.regions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = armoryManager.regions[row]
    }
    
}

//MARK: - ArmoryManagerDelegate

extension InputViewController: ArmoryManagerDelegate {
    func didUpdateArmory(_ armoryManager: ArmoryManager, armory: armoryModel) {
        DispatchQueue.main.async {[self] in
            classResult = armory.className
            raceResult = armory.raceName
            specResult = armory.specName
            factionResult = UIImage(named: armory.factionName)
            self.performSegue(withIdentifier: "ShowResult", sender: self)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UITextFieldDelegate

extension InputViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let realmInputValue = realmInput.text!
        let nameInputValue = nameInput.text!
        let selectedRegion = selected
        
        armoryManager.fetchArmory(region: selectedRegion, realm: realmInputValue, name: nameInputValue)
        return true
    }
}

