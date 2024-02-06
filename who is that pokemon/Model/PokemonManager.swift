//
//  PokemonManager.swift
//  who is that pokemon
//
//  Created by Jozek Hajduk on 5/02/24.
//

import Foundation

protocol PokemonManagerDelegate {
    func didUpdatePokemon(pokemons: [PokemonModel])
    func didFailWithError(error: Error)
}

struct PokemonManager {
    let pokemonUrl: String = "https://pokeapi.co/api/v2/pokemon?limit=100"
    var delegate: PokemonManagerDelegate?
    
    func fecthPokemonData() {
        perfromRequest(with: pokemonUrl)
    }
    
    private func perfromRequest(with url: String) {
        // 1. Create URL
        guard let newUrl = URL(string: url) else { return }
        // 2. Crreate URL session to fecth data
        let session = URLSession(configuration: .default)
        // 3. Create Task to handle data from fecth
        let task = session.dataTask(with: newUrl) { data, response, error in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
            }
            guard let safeData = data else { return }
            guard let pokemons = self.parseJSON(pokemonData: safeData) else { return }
            self.delegate?.didUpdatePokemon(pokemons: pokemons)
        }
        // 4. Ejecuta la tarea
        task.resume()
    }
    
    private func parseJSON(pokemonData: Data) -> [PokemonModel]? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(PokemonData.self, from: pokemonData)
            let pokemon = decodeData.results?.map { PokemonModel(name: $0.name, imageUrl: $0.url) }
            return pokemon
        } catch {
            return nil
        }
    }
}
