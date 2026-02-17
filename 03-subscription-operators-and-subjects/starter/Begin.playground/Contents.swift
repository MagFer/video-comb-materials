import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()


/// Subscribe using sink
///
example(of: "Just") {
    let just = Just("Hellow World")
    
    just
        .sink { completion in
            print("Completion: \(completion)")
        } receiveValue: { value in
            print("Received Value: \(value)")
        }
        .store(in: &subscriptions)
}

example(of: "assing(to:on:)") {
    class SomeObject {
        var value: String = "" {
            didSet {
                print("Value is now \(value)")
            }
        }
    }
    
    let object = SomeObject()
    
    /// Subscribe using Assing by KVO
    ///
    ["Hello", "World"].publisher
        .assign(to: \.value, on: object)
        .store(in: &subscriptions)
    
    /// Subscribe using Assing by sink
    ///
    ["Hello", "World"].publisher
        .sink(receiveValue: { value in
            print("sink: \(value)")
        })
        .store(in: &subscriptions)
}

example(of: "PassthroughSubject") {
    let subject = PassthroughSubject<String, Never>()
    
    subject
        .sink(receiveValue: { value in
            print("Received Value: \(value)")
        })
        .store(in: &subscriptions)
    
    subject.send("Hello")
    subject.send("World")
    subject.send(completion: .finished)
    subject.send("Still there?")
}

example(of: "CurrentValueSubject") {
    let subject = CurrentValueSubject<Int, Never>(0)
    
    subject
        .print()
        .sink(receiveValue: { value in
            //print("Received Value: \(value)")
        })
        .store(in: &subscriptions)
    
    print(subject.value)
    
    subject.send(1)
    subject.send(2)
    
    print(subject.value)
    
    subject.send(completion: .finished)
}

example(of: "Type erasure") {
    let subject = PassthroughSubject<Int, Never>()
    
    let publisher = subject.eraseToAnyPublisher()
    
    // A generic publisher forbbits from sending events
    // publisher.send(0)
    
    publisher
        .sink { value in
            print("Received Value: \(value)")
        }
        .store(in: &subscriptions)
    
    subject.send(0)
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
