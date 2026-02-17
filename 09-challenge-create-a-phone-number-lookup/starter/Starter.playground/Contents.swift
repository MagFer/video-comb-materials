import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "Create a phone number lookup") {
  let contacts = [
    "603-555-1234": "Florent",
    "408-555-4321": "Marin",
    "217-555-1212": "Scott",
    "212-555-3434": "Shai"
  ]

  func convert(phoneNumber: String) -> Int? {
    if let number = Int(phoneNumber),
      number < 10 {
      return number
    }

    let keyMap: [String: Int] = [
      "abc": 2, "def": 3, "ghi": 4,
      "jkl": 5, "mno": 6, "pqrs": 7,
      "tuv": 8, "wxyz": 9
    ]

    let converted = keyMap
      .filter { $0.key.contains(phoneNumber.lowercased()) }
      .map { $0.value }
      .first

    return converted
  }

  func format(digits: [Int]) -> String {
    var phone = digits.map(String.init)
                      .joined()

    phone.insert("-", at: phone.index(
      phone.startIndex,
      offsetBy: 3)
    )

    phone.insert("-", at: phone.index(
      phone.startIndex,
      offsetBy: 7)
    )

    return phone
  }
  
  func dial(phoneNumber: String) -> String {
    guard let contact = contacts[phoneNumber] else {
      return "Contact not found for \(phoneNumber)"
    }

    return "Dialing \(contact) (\(phoneNumber))..."
  }


  /// 1. P. Receive an string of 10 characters
  /// 2. Look at the numbers in a data structure
  /// 3.1. Subscribe to conver input to numbers
  ///  3.2 replace nil with 0
  ///
  /// 4.Format 3 digits for country code + 7 phone digits
  /// 5.Dial phone number
  ///

  let input = PassthroughSubject<String, Never>()
  
  input
    .map(convert)
    .replaceNil(with: 0)
    .collect(10)
    .map(format)
    .map(dial)
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
  
//    .map { character in
//      convert(phoneNumber: String(character))
//    }
//    .map { tenNumbers in
//      format(digits: tenNumbers)
//    }
    //.store(in: &subscriptions)
    
  "0!1234567".forEach {
    input.send(String($0))
  }
    
  "4085554321".forEach {
  input.send(String($0))
  }
    
  "A1BJKLDGEH".forEach {
  input.send("\($0)")
  }
  
  print("\nMy solution:\n")
  
  let numberPublisher = PassthroughSubject<String, Never>()
  numberPublisher
    .map({ character in
      return String(character)
    })
    .map({ value in
      let number = convert(phoneNumber: value)
      return number
    })
    .replaceNil(with: 0)
    .collect(10)
    .map({ tenNumbers in
      format(digits: tenNumbers)
    })
    .sink { value in
      print(dial(phoneNumber: value))
    }
    .store(in: &subscriptions)
  
  let happyPhoneNumber = "6035551234"
  happyPhoneNumber.forEach { character in
    numberPublisher.send(String(character))
  }
  let happyLettersNumber = "603JJJ1234"
  happyLettersNumber.forEach { character in
    numberPublisher.send(String(character))
  }
  let badPhoneNumber = "603555123"
  badPhoneNumber.forEach { character in
    numberPublisher.send(String(character))
  }
}

/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
