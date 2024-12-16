//
//  ViewModel.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 12/10/24.
//

import UIKit

protocol ViewModel where Self: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
