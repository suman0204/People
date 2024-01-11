//
//  Extension+String.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/08.
//

import Foundation

//전화번호 대응 코드 ('-'자동 입력, 숫자 입력 감지)
extension String {
    var decimalFilteredString: String {
        return String(unicodeScalars.filter(CharacterSet.decimalDigits.contains))
    }
    
    func formated(by patternString: String) -> String {
        let digit: Character = "#"
 
        let pattern: [Character] = Array(patternString)
        let input: [Character] = Array(self.decimalFilteredString)
        var formatted: [Character] = []
 
        var patternIndex = 0
        var inputIndex = 0
 
        // 2
        while inputIndex < input.count {
            let inputCharacter = input[inputIndex]
 
            // 2-1
            guard patternIndex < pattern.count else { break }
 
            switch pattern[patternIndex] == digit {
            case true:
                // 2-2
                formatted.append(inputCharacter)
                inputIndex += 1
            case false:
                // 2-3
                formatted.append(pattern[patternIndex])
            }
 
            patternIndex += 1
        }
 
        // 3
        return String(formatted)
    }
    
    func validatePassword() -> Bool {
        let regEx = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*()_+])[A-Za-z\\d!@#$%^&*()_+]{8,}$"
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: self)
    }
    
    //전화번호 정규식 및 하이픈 대응
    func validatePhoneNumber() -> Bool {
        let phoneRegex = "^01[0-9]-?[0-9]{3,4}-?[0-9]{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
//
//    func formatPhoneNumber() -> String {
//        var cleanedPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
//        
//        // Check if the number starts with "0" and remove it
//        var formattedNumber = cleanedPhoneNumber.hasPrefix("0") ? String(cleanedPhoneNumber.dropFirst()) : cleanedPhoneNumber
//
//        
//        let length = cleanedPhoneNumber.count
//        
//        if length == 10 {
//            let firstPart = formattedNumber.prefix(3)
//            let secondPart = formattedNumber.dropFirst(3).prefix(3)
//            let thirdPart = formattedNumber.dropFirst(6)
//            return "\(firstPart)-\(secondPart)-\(thirdPart)"
//        } else if length == 11 {
//            let firstPart = formattedNumber.prefix(3)
//            let secondPart = formattedNumber.dropFirst(3).prefix(4)
//            let thirdPart = formattedNumber.dropFirst(7)
//            return "\(firstPart)-\(secondPart)-\(thirdPart)"
//        } else {
//            // Return the original string if it doesn't match the expected length
//            return self
//        }
//    }
    // Updated phone number validation method
//    func validatePhoneNumber() -> Bool {
//        let phoneRegex = "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$"
//        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
//        return phoneTest.evaluate(with: self)
//    }

    // Updated phone number formatting method
    func formatPhoneNumber() -> String {
        let cleanedPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        // Check if the number starts with "0" and remove it
        let formattedNumber = cleanedPhoneNumber.hasPrefix("0") ? String(cleanedPhoneNumber.dropFirst()) : cleanedPhoneNumber

        let length = formattedNumber.count

        if length == 10 {
            let firstPart = formattedNumber.prefix(3)
            let secondPart = formattedNumber.dropFirst(3).prefix(3)
            let thirdPart = formattedNumber.dropFirst(6)
            return "\(firstPart)-\(secondPart)-\(thirdPart)"
        } else if length == 11 {
            let firstPart = formattedNumber.prefix(3)
            let secondPart = formattedNumber.dropFirst(3).prefix(4)
            let thirdPart = formattedNumber.dropFirst(7)
            return "\(firstPart)-\(secondPart)-\(thirdPart)"
        } else {
            // Return the original string if it doesn't match the expected length
            return self
        }
    }
    
//    func test() -> String {
//        var stringWithHypen: String = self
//        
//        stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.startIndex, offsetBy: 3))
//        stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.endIndex, offsetBy: -4))
//        
//        return stringWithHypen
//    }

}
