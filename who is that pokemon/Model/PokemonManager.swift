//
//  PokemonManager.swift
//  who is that pokemon
//
//  Created by Jozek Hajduk on 5/02/24.
//

import Foundation

struct PokemonManager {
    let pokemonUrl: String = "https://pokeapi.co/api/v2/pokemon?limit=100"
    
    func fetchData(with url: String) {
        // 1. Create URL
        guard let newUrl = URL(string: url) else {
            print("Error creating URL")
            return
        }
        // 2. Crreate URL session to fecth data
        let session = URLSession(configuration: .default)
        // 3. Create Task to handle data from fecth
        let task = session.dataTask(with: newUrl) { data, response, error in
            if error != nil {
                print(error!)
                return
            }
            guard let safeData = data else {
                print("Error with the data")
                return
            }
            guard let pokemon = self.parseJSON(pokemonData: safeData) else {
                print("Error prsing pokemon")
                return
            }
            print(pokemon)
        }
        // 4. Ejecuta la tarea
        task.resume()
    }
    
    func parseJSON(pokemonData: Data) -> [PokemonModel]? {
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
