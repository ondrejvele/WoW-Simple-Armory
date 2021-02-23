//
//  ResultViewController.swift
//  WoW Simple Armory
//
//  Created by Ondřej Vele on 16.02.2021.
//

import UIKit

class ResultViewController: UIViewController {
    
    var charClass: String?
    var charRace: String?
    var charSpec: String?
    var charFaction: UIImage?

    @IBOutlet weak var raceResult: UILabel!
    @IBOutlet weak var classResult: UILabel!
    @IBOutlet weak var specResult: UILabel!
    @IBOutlet weak var factionImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        raceResult.text = charRace
        classResult.text = charClass
        specResult.text = charSpec
        factionImage.image = charFaction

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
