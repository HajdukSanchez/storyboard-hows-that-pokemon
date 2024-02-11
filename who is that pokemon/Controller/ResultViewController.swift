//
//  ResultViewController.swift
//  who is that pokemon
//
//  Created by Jozek Hajduk on 11/02/24.
//

import UIKit
import Kingfisher

class ResultViewController: UIViewController {

    @IBOutlet weak var uiLabelMessage: UILabel!
    @IBOutlet weak var uiImage: UIImageView!
    @IBOutlet weak var uiLabelScore: UILabel!
    
    var pokemonName: String = ""
    var pokemonImage: String = ""
    var finalScore: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uiLabelScore.text = "Perdiste, tu puntaje fue de \(finalScore)"
        uiLabelMessage.text = "No, es un \(pokemonName)"
        uiImage.kf.setImage(with: URL(string: pokemonImage))
    }
    
    @IBAction func onPlayAgain(_ sender: UIButton) {
        self.dismiss(animated: true) // Fade transition on exit view
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
