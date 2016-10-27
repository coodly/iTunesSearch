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

private typealias Dictionary = [String: AnyObject]

public struct SearchHit {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }()
    public let trackName: String
    public let artistName: String
    public let trackId: Int
    public let artworkUrl30: URL
    public let artworkUrl60: URL
    public let artworkUrl100: URL
    public let releaseDate: Date
    public let primaryGenreName: String
    public let price: Price?
    
    static func loadResults(_ data: [String: AnyObject]) -> [SearchHit] {
        guard let results = data["results"] as? [Dictionary] else {
            Logging.log("results element not found")
            return []
        }
        
        var hits = [SearchHit]()
        
        for result in results {
            guard let loaded = loadHitFromData(result) else {
                continue
            }
            
            hits.append(loaded)
        }
                
        return hits
    }
    
    static func loadHitFromData(_ data: [String: AnyObject]) -> SearchHit? {
        guard let trackName = data["trackName"] as? String else {
            Logging.log("track name not found")
            return nil
        }
        
        guard let trackId = data["trackId"] as? Int else {
            Logging.log("trackId not found")
            return nil
        }
        
        guard let artwork30 = data["artworkUrl30"] as? String, let artworkUrl30 = URL(string: artwork30) else {
            Logging.log("artworkUrl30 not found")
            return nil
        }

        guard let artwork60 = data["artworkUrl60"] as? String, let artworkUrl60 = URL(string: artwork60) else {
            Logging.log("artworkUrl60 not found")
            return nil
        }

        guard let artwork100 = data["artworkUrl100"] as? String, let artworkUrl100 = URL(string: artwork100) else {
            Logging.log("artworkUrl100 not found")
            return nil
        }
        
        guard let dateString = data["releaseDate"] as? String, let date = SearchHit.dateFormatter.date(from: dateString) else {
            Logging.log("Release date not found")
            return nil
        }
        
        guard let artistName = data["artistName"] as? String else {
            Logging.log("Artist name not found")
            return nil
        }
        
        guard let primaryGenre = data["primaryGenreName"] as? String else {
            Logging.log("No genre name")
            return nil
        }
        
        let price = Price.loadFromData(data)
        
        return SearchHit(trackName: trackName, artistName: artistName, trackId: trackId, artworkUrl30: artworkUrl30, artworkUrl60: artworkUrl60, artworkUrl100: artworkUrl100, releaseDate: date, primaryGenreName: primaryGenre, price: price)
    }
}