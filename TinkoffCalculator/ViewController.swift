//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by @_@ on 25.01.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let titleText = sender.currentTitle else { return }
        print(titleText)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

