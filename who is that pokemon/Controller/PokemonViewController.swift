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
    
    lazy var pokemonManager = PokemonManager()
    lazy var imageManager = ImageManager()
    var randomPokemons: [PokemonModel] = []
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
