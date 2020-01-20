import UIKit

// Create Person struct, conforming to decodable
struct Person: Decodable {
    var name: String
    var films: [URL]
}

// Create Film struct, conforming to decodable
struct Film: Decodable {
    var title: String
    var opening_crawl: String
    var release_date: String
}

// Create SwapiService class, which will fetch data from SWAPI and parse it into the models
class SwapiService {
    
    static private let baseURL = URL(string: "https://swapi.co/api/")
    static private let personPathComponent = "people"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // 1. Prepare URL
        guard let baseURL = baseURL else { return completion(nil) }
        
        // 2. Contact server
        let personURL = baseURL.appendingPathComponent(personPathComponent)
        let finalURL = personURL.appendingPathComponent(String(id))
        print(finalURL)
        
        // 3. DataTask
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            
            // 4. Handle error
            if let error = error {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            
            // 5. Check for data
            guard let data = data else { return completion(nil) }
            do {
                // 6. Decode JSON
                let decoder = try JSONDecoder().decode(Person.self, from: data)
                completion(decoder)
            } catch {
                print(error, error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
}

SwapiService.fetchPerson(id: 1) { (person) in
    if let person = person {
        print(person)
    }
}
