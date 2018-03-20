//
//  ViewModelType.swift
//  Countries
//
//  Created by Mikhail Polyevin on 17/03/2018.
//  Copyright © 2018 MP. All rights reserved.
//

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func bind(input: Input) -> Output
}
