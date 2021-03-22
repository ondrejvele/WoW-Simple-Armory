//
//  ViewController.swift
//  WoW Simple Armory
//
//  Created by Ondřej Vele on 18.01.2021.
//

import UIKit

class InputViewController: UIViewController {
    
    var selectedRegion = ""
    
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
        //realmInput.text = "Drakthul"
        //nameInput.text = "Skymonk"

        
        regionPicker.dataSource = self
        regionPicker.delegate = self
        armoryManager.delegate = self
        
        realmInput.delegate = self
        nameInput.delegate = self
        
        selectedRegion = armoryManager.regions[0]
        
    }
    
    //MARK: - SearchPressed
    
    @IBAction func searchPressed(_ sender: UIButton) {
        
        armoryManager.fetchArmory(region: selectedRegion, realm: realmInput.text!, name: nameInput.text!)
        
        realmInput.endEditing(true)
        nameInput.endEditing(true)
        
        
    }
    
    //MARK: - Prepare for Segue
    
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
        selectedRegion = armoryManager.regions[row]
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
            performSegue(withIdentifier: "ShowResult", sender: self)
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
        
        armoryManager.fetchArmory(region: selectedRegion, realm: realmInput.text!, name: nameInput.text!)
        return true
    }
}

