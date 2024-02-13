//
//  ViewController.swift
//  who is that pokemon
//
//  Created by Alex Camacho on 01/08/22.
//

import UIKit
import Kingfisher

class PokemonViewController: UIViewController {

    @IBOutlet var uiButtons: [UIButton]!
    @IBOutlet weak var uiLabelMessage: UILabel!
    @IBOutlet weak var uiImage: UIImageView!
    @IBOutlet weak var uiLabelScore: UILabel!
    
    lazy var pokemonManager = PokemonManager()
    lazy var imageManager = ImageManager()
    lazy var gameModel = GameModel()
    
    var randomPokemons: [PokemonModel] = [] {
        didSet {
            // set buttons after the value of the array change
            setButtonTitles()
        }
    }
    var correctAnswer: String = ""
    var correctAnswerImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleScoreText()
        createButtonsStyle()
        
        // Set into the pokemonManager instance the delegate defined in the extension
        pokemonManager.delegate = self
        imageManager.delegate = self
        pokemonManager.fecthPokemonData()
        uiLabelMessage.text = ""
    }
    
    func handleScoreText() {
        // Update lable on start
        uiLabelScore.text = "Puntaje: 0"
    }
    
    func createButtonsStyle() {
        // Change each button on start
        for button in uiButtons {
            button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowOpacity = 1
            button.layer.shadowRadius = 0
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = false
        }
    }
    
    func setButtonTitles() {
        // Set titles on each button based on 4 pokemons getted
        for (index, button) in uiButtons.enumerated() {
            DispatchQueue.main.async {
                button.setTitle(self.randomPokemons[safe: index]?.name.capitalized, for: .normal)
            }
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let userAnswer = sender.title(for: .normal) ?? ""
        if gameModel.checkAnswer(userAnswer, correctAnswer) {
            uiLabelMessage.text = "Si, es un \(userAnswer.capitalized)"
            uiLabelScore.text = "Puntaje: \(gameModel.score)"
            
            sender.layer.borderColor = UIColor.systemGreen.cgColor
            sender.layer.borderWidth = 2
            
            // Set the correct image without effect
            let url = URL(string: correctAnswerImage)
            uiImage.kf.setImage(with: url)
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                // Get new pokemons to change answer
                self.pokemonManager.fecthPokemonData()
                self.uiLabelMessage.text = ""
                sender.layer.borderWidth = 0
            }
        } else {
            // Reset score
            Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { timer in
                self.resetGame(sender)
            }
            self.performSegue(withIdentifier: "goToResults", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResults" {
            let destination = segue.destination as! ResultViewController
            destination.pokemonName = correctAnswer
            destination.pokemonImage = correctAnswerImage
            destination.finalScore = gameModel.score
        }
    }
    
    func resetGame(_ sender: UIButton) {
        self.pokemonManager.fecthPokemonData()
        gameModel.setScore(score: 0)
        uiLabelScore.text = "Puntaje: \(gameModel.score)"
        uiLabelMessage.text = ""
        sender.layer.borderWidth = 0
    }
}

// Extend the functionality of the current controller class
extension PokemonViewController: PokemonManagerDelegate {
    func didUpdatePokemon(pokemons: [PokemonModel]) {
        randomPokemons = pokemons.choose(4)
        
        let index = Int.random(in: 0...3)
        let imageData = randomPokemons[index].imageUrl
        correctAnswer = randomPokemons[index].name
        
        // Get pokemon image URL
        imageManager.fecthImageData(imageData)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension PokemonViewController: ImageManagerDelegate {
    func didUpdateImage(pokemonImage: ImageModel) {
        correctAnswerImage = pokemonImage.imageUrl
        // We use this to handle process async while the UI is loading
        DispatchQueue.main.async {
            // Create an url to get the image async
            let url = URL(string: pokemonImage.imageUrl)
            // Create the black effect for the image
            let effectImage = ColorControlsProcessor(brightness: -1, contrast: 1, saturation: 1, inputEV: 0)
            // Set the image and the effect to the component
            self.uiImage.kf.setImage(with: url, options: [.processor(effectImage)])
        }
    }
    
    func didFailWithErrorImage(error: Error) {
        print(error)
    }
}

extension Collection {
    func choose(_ n: Int) -> Array<Element> {
        // Get 4 random pokemons from the list
        Array(shuffled().prefix(n))
    }
}

extension Collection where Indices.Iterator.Element == Index {
    // Override the method to get a value from and index
    // That means, if we have a list of 4 elements and we want to get the index in the position 10,
    // We are going to return a nil value and not an error
    public subscript(safe index: Index) -> Iterator.Element? {
        return (startIndex <= index && index < endIndex) ? self[index] : nil
    }
}
