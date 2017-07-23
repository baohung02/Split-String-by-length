//
//  ZTStringExtension.swift
//  Zalora Testing
//
//  Created by Jack on 7/22/17.
//  Copyright © 2017 Htuinngh. All rights reserved.
//

import Foundation

extension String {
    func splitByLength(_ length: Int) -> [String] {
        
        
        let groups = self.components(separatedBy: " ")
        
        // Smaller is 3 (index/count)
        var indicatorLength = 3
        
        // Predicting number messages in results
        var countPredict = self.characters.count/(length - indicatorLength)
        
        // We will loop countPredict until find result or reach string length.
        while countPredict < self.characters.count {
            let results = self.split_(length, indicatorLength, groups)
            
            
            // Invalid character
            if results.count == 0 {
                return results
            }
            
            // Validate results
            if self.verifyMessages(results, length) {
                return results
            }
            else
            {
                // Increase predict count
                while countPredict < self.characters.count {
                    countPredict += 1
                    let calculated = self.calculateMinOfIndicatorText(countPredict)
                    
                    
                    // If length of predict count changed, should update indicator length then loop again.
                    if calculated > indicatorLength{
                        indicatorLength = calculated
                        break
                    }
                }
            }
            
        }
        
        return [String]()
    }
    
    private func calculateMinOfIndicatorText(_ value: Int) -> Int {
        if value <= 0 {
            return 0
        }
        
        return String(value).characters.count + 2 // 2 is for index vs /
    }
    
    private func verifyMessages(_ messages: [String],_ length: Int) -> Bool {
        
        for message in messages {
            if message.characters.count > length {
                return false
            }
        }
        
        return true
    }
    
    private func split_(_ length: Int,_ indicatorLength: Int, _ groups: [String]) -> [String] {
        
        var results = [String]()
        
        var collectedCharacters = [Character]()
        collectedCharacters.reserveCapacity(length)
        
        var indicator = indicatorLength
        var tempLength = indicatorLength
        var temp = 0
    
        
        var resultNumber = 1
        
        for group in groups {
            
            // Return empty array if character too long
            if group.characters.count + indicator > length {
                return []
            }
            
            
            temp += group.characters.count
            
            // If length of new element vs temp string larger then limit length
            if group.characters.count + tempLength >= length {
                
                // add temp string to result array
                results.append(String(collectedCharacters))
                collectedCharacters.removeAll(keepingCapacity: true)
                
                let oldder = String(resultNumber).characters.count
                resultNumber += 1
                let newer = String(resultNumber).characters.count
                
                // Update indicator length follow index
                if newer > oldder{
                    indicator += 1
                }
                
                // Re-assign length for new temporary string
                tempLength = indicator
            }
            
            // Append new element to temporary array
            collectedCharacters.append(" ")
            collectedCharacters += group.characters
            
            tempLength += (group.characters.count + 1)
            
        }
        
        // Append the remainder
        if !collectedCharacters.isEmpty {
            results.append(String(collectedCharacters))
        }
        
        // Generate final result
        var index = 1
        
        for item in results {
            var prefix = "\(index)/\(results.count)"
            prefix += item
            results[index-1] = prefix
            index += 1
        }
        
        return results
    }
}
