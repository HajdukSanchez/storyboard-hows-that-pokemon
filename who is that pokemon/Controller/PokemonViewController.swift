//
//  ViewController.swift
//  who is that pokemon
//
//  Created by Alex Camacho on 01/08/22.
//

import UIKit

class PokemonViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var lableMessage: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lableScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleScoreText()
        createButtonsStyle()
    }
    
    func handleScoreText() {
        // Update lable on start
        lableScore.text = "Puntaje: 100"
    }
    
    func createButtonsStyle() {
        // Change each button on start
        for button in buttons {
            button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowOpacity = 1
            button.layer.shadowRadius = 0
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = false
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        print(sender.title(for: .normal) ?? "Nothing")
    }
}
