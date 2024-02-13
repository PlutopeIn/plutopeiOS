//
//  Observable.swift
//  PlutoPe
//
//  Created by Mitali Desai on 22/05/23.
//
import Foundation
import UIKit
class Observable<T> {
    
    typealias Listener = (T) -> Void
    var listener:Listener?
    
    var value: T {
        didSet {
            listener?(value)
         } 
     } 
    
    init(_ value:T) {
        self.value = value
     } 
    
    func observe( listener:@escaping Listener) {
        self.listener = listener
     } 
    
 } 
