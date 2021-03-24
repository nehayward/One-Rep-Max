//
//  ImportError.swift
//  
//
//  Created by Nick Hayward on 3/24/21.
//

import Foundation

public enum ImportError: Error {
    /// Data was malformed or not formatted correctly, expects `Date of workout, Exercise Name, Sets, Reps, Weight.` i.e = **Oct 31 2019,Barbell Bench Press,1,10,175**
    case invalidData
}
