//
//  ImageManager.swift
//  who is that pokemon
//
//  Created by Jozek Hajduk on 5/02/24.
//

import Foundation

protocol ImageManagerDelegate {
    func didUpdateImage(pokemonImage: ImageModel)
    func didFailWithErrorImage(error: Error)
}

struct ImageManager {
    var delegate: ImageManagerDelegate?
    
    func fecthImageData(_ url: String) {
        perfromRequest(with: url)
    }
    
    private func perfromRequest(with url: String) {
        guard let newUrl = URL(string: url) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: newUrl) { data, response, error in
            if error != nil {
                delegate?.didFailWithErrorImage(error: error!)
            }
            guard let safeData = data else { return }
            guard let pokemonImage = self.parseJSON(imageData: safeData) else { return }
            self.delegate?.didUpdateImage(pokemonImage: pokemonImage)
        }
        task.resume()
    }
    
    private func parseJSON(imageData: Data) -> ImageModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(ImageData.self, from: imageData)
            let image = ImageModel(imageUrl: decodeData.sprites.other.officialArtwork.frontDefault)
            return image
        } catch {
            return nil
        }
    }
}
    
