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

public struct Price {
    public let currency: String
    public let trackPrice: NSDecimalNumber
    public let trackHdPrice: NSDecimalNumber?
    public let trackRentalPrice: NSDecimalNumber?
    public let trackHdRentalPrice: NSDecimalNumber?
    
    static func loadFromData(_ data: [String: AnyObject]) -> Price? {
        guard let currency = data["currency"] as? String else {
            Logging.log("No currency")
            return nil
        }
        
        guard let trackPrice = data["trackPrice"] as? Double else {
            Logging.log("No track price")
            return nil
        }
        
        let trackRentalPrice = data["trackRentalPrice"] as? Double
        let trackHdPrice = data["trackHdPrice"] as? Double
        let trackHdRentalPrice = data["trackHdRentalPrice"] as? Double
        
        return Price(currency: currency, trackPrice: trackPrice.decimalNumber(), trackHdPrice: trackHdPrice?.decimalNumber(), trackRentalPrice: trackRentalPrice?.decimalNumber(), trackHdRentalPrice: trackHdRentalPrice?.decimalNumber())
    }
}

private extension Double {
    func decimalNumber() -> NSDecimalNumber {
        return NSDecimalNumber(decimal: NSNumber(value: self).decimalValue)
    }
}
