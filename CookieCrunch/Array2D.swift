//
//  Array2D.swift
//  CookieCrunch
//
//  Created by Pierre Branéus on 2014-06-26.
//  Copyright (c) 2014 Pierre Branéus. All rights reserved.
//

class Array2D<T> {
    let columns: Int
    let rows: Int
    let array: Array<T?> // private
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(count: rows*columns, repeatedValue: nil)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get {
            return array[row*columns + column]
        }
        set {
            array[row*columns + column] = newValue
        }
    }
}

