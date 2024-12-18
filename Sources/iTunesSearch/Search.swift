/*
 * Copyright 2016 Coodly LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

public enum Media: String, Sendable {
  case movie
  case podcast
  case music
  case musicVideo
  case audiobook
  case shortFilm
  case tvShow
  case software
  case ebook
  case all
}

public typealias SearchResultClosure = ([SearchHit], Error?) -> ()

private let APIServer = "https://itunes.apple.com"

public struct Search: Sendable {
  private let fetch: NetworkFetch
  
  public init(networkFetch: NetworkFetch) {
    self.fetch = networkFetch
  }
  
  private func get<Result: Decodable>(path: String, parameters: [String: String]) async throws -> Result {
    var components = URLComponents(url: URL(string: APIServer)!, resolvingAgainstBaseURL: true)!
    components.path = components.path + path
        
    var queryItems = [URLQueryItem]()
          
    for (name, value) in parameters {
      queryItems.append(URLQueryItem(name: name, value: value))
    }
          
    components.queryItems = queryItems
        
    let requestURL = components.url!
    let request = NSMutableURLRequest(url: requestURL)
    request.httpMethod = "GET"

    let (data, response) = try await URLSession.shared.data(for: request as URLRequest)
    
    let decoder = JSONDecoder()
            
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    decoder.dateDecodingStrategy = .formatted(formatter)
    
    do {
      return try decoder.decode(Result.self, from: data)
    } catch let error as NSError {
      if let tunesError = try? decoder.decode(TunesError.self, from: data) {
        throw tunesError
      } else {
        throw error
      }
    }
  }

  public func search(_ media: Media = .movie, term: String, country: String = "US", limit: Int = 50) async throws -> [SearchHit] {
    let searchParams: [String: String] = [
      "term": term.replacingOccurrences(of: " ", with: "+"),
      "media": media.rawValue,
      "country": country,
      "limit": String(describing: limit)
    ]
    let result: SearchResults = try await get(path: "/search", parameters: searchParams)
    return result.results
  }

  public func lookup(of id: Int, in country: String) async throws -> [SearchHit] {
    Logging.log("Perform lookup for \(id)")
    let result: SearchResults = try await get(path: "/lookup", parameters: ["id": String(describing: id), "country": country])
    return result.results
  }
}
