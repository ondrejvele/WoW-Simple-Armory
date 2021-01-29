//
//  ViewController.swift
//  WoW Simple Armory
//
//  Created by Ondřej Vele on 18.01.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var selected = ""

    @IBOutlet weak var realmInput: UITextField!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var regionPicker: UIPickerView!
    
    @IBOutlet weak var raceResult: UILabel!
    @IBOutlet weak var classResult: UILabel!
    @IBOutlet weak var specResult: UILabel!
    
    @IBOutlet weak var factionImage: UIImageView!
    
    var armoryManager = ArmoryManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //for test purpose
        realmInput.text = ""
        nameInput.text = ""
        
        raceResult.text = ""
        classResult.text = ""
        specResult.text = ""
        
        regionPicker.dataSource = self
        regionPicker.delegate = self
        armoryManager.delegate = self
        
        realmInput.delegate = self
        nameInput.delegate = self
        
        selected = armoryManager.regions[0]
    }
    
}

//MARK: - Picker View

extension ViewController : UIPickerViewDataSource, UIPickerViewDelegate {
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

extension ViewController: ArmoryManagerDelegate {
    func didUpdateArmory(_ armoryManager: ArmoryManager, armory: armoryModel) {
        DispatchQueue.main.async {[self] in
            raceResult.text = armory.raceName
            classResult.text = armory.className
            specResult.text = armory.specName
            factionImage.image = UIImage(named: armory.factionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UITextFieldDelegate

extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let realmInputValue = realmInput.text!
        let nameInputValue = nameInput.text!
        let selectedRegion = selected
        
        armoryManager.fetchArmory(region: selectedRegion, realm: realmInputValue, name: nameInputValue)
        return true
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        let realmInputValue = realmInput.text!
        let nameInputValue = nameInput.text!
        let selectedRegion = selected
        
        armoryManager.fetchArmory(region: selectedRegion, realm: realmInputValue, name: nameInputValue)
        
        realmInput.endEditing(true)
        nameInput.endEditing(true)
        
    }
}

