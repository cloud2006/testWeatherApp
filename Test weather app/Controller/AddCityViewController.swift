//
//  AddCityViewController.swift
//  Test weather app
//
//  Created by Pavel Antoniuk on 10/16/18.
//  Copyright © 2018 Pavel Antoniuk. All rights reserved.
//

import UIKit

class AddCityViewController: UIViewController {
    
    @IBOutlet weak var addCityTextField: UITextField!
    
    var addCity: ((String) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addPressed() {
        addCity?(addCityTextField.text!)
        navigationController?.popViewController(animated: true)
    }
}
