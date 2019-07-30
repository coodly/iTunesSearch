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

internal struct SearchResults: Codable {
    let resultCount: Int
    let results: [SearchHit]
}

public struct SearchHit: Codable {
    public let trackId: Int
    public let trackName: String
    public let releaseDate: Date
    public let artworkUrl30: URL
    public let artworkUrl60: URL
    public let artworkUrl100: URL
    public let longDescription: String
}
