//
//  Vector.swift
//  AnotherMetalTest
//
//  Created by brian jones on 8/5/15.
//  Copyright © 2015 brian jones. All rights reserved.
//

import Foundation
import QuartzCore

extension Int {
    var degreesToRadians: Float {
        return Float(self) * Float(M_PI) / Float(180.0)
    }
}

struct Vector3 {
    var x, y, z: Float
    
    init() {
        x = 0.0
        y = 0.0
        z = 0.0
    }
    
    init(all: Float) {
        x = all
        y = all
        z = all
    }
    
    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    init(v: Vector3) {
        x = v.x
        y = v.y
        z = v.z
    }
    
    func add(other: Vector3) -> Vector3 {
        return Vector3(x: x + other.x, y: y + other.y, z: z + other.z)
    }
    
    func subtract(other: Vector3) -> Vector3 {
        return Vector3(x: x - other.x, y: y - other.y, z: z - other.z)
    }
    
    func multiply(scalar: Float) -> Vector3 {
        return Vector3(x: x * scalar, y: y * scalar, z: z * scalar)
    }
    
    func divide(scalar: Float) -> Vector3 {
        return Vector3(x: x / scalar, y: y / scalar, z: z / scalar)
    }
    
    func length() -> Float {
        return sqrt(x * x + y * y + z * z)
    }
    
    func normalized() -> Vector3 {
        let l = length()
        return Vector3(x: self.x / l, y: y / l, z: z / l)
    }
    
    func dot(other: Vector3) -> Float {
        return (x * other.x + y * other.y + z * other.z)
    }
    
    func cross(other: Vector3) -> Vector3 {
        return Vector3(x: (y * other.z) - (z * other.y), y: (z * other.x) - (x * other.z), z: (x * other.y) - (y * other.x))
    }
}

struct Vector4 {
    var x, y, z, w: Float
    
    init() {
        x = 0.0
        y = 0.0
        z = 0.0
        w = 0.0
    }
    
    init(all: Float) {
        x = all
        y = all
        z = all
        w = all
    }
    
    init(x: Float, y: Float, z: Float, w: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    
    init(v: Vector4) {
        x = v.x
        y = v.y
        z = v.z
        w = v.w
    }
    
    func add(other: Vector4) -> Vector4 {
        return Vector4(x: x + other.x, y: y + other.y, z: z + other.z, w: w + other.w)
    }
    
    func subtract(other: Vector4) -> Vector4 {
        return Vector4(x: x - other.x, y: y - other.y, z: z - other.z, w: w - other.w)
    }
    
    func multiply(scalar: Float) -> Vector4 {
        return Vector4(x: x * scalar, y: y * scalar, z: z * scalar, w: w * scalar)
    }
    
    func divide(scalar: Float) -> Vector4 {
        return Vector4(x: x / scalar, y: y / scalar, z: z / scalar, w: w / scalar)
    }
    
    func length() -> Float {
        return sqrt(x * x + y * y + z * z + w * w)
    }
    
    func normalized() -> Vector4 {
        let l = length()
        return Vector4(x: self.x / l, y: y / l, z: z / l, w: w / l )
    }
    
    func dot(other: Vector4) -> Float {
        return (x * other.x + y * other.y + z * other.z + w * other.w)
    }
    
    var array: [Float] {
        get {
            return [x, y, z, w]
        }
        
        set {
            x = newValue[0]
            y = newValue[1]
            z = newValue[2]
            w = newValue[3]
        }
    }
}

struct Matrix {
    var matrix: [Float]
    
    init() {
        matrix = [1.0, 0.0, 0.0, 0.0,
            0.0, 1.0, 0.0, 0.0,
            0.0, 0.0, 1.0, 0.0,
            0.0, 0.0, 0.0, 1.0]
    }
    
    init(m: [Float]) {
        if m.count != 16 {
            fatalError("m matrix must be of length 16")
        }
        matrix = m
    }
    
    static func identity() -> Matrix{
        var m = Matrix()
        m.matrix = [1.0, 0.0, 0.0, 0.0,
            0.0, 1.0, 0.0, 0.0,
            0.0, 0.0, 1.0, 0.0,
            0.0, 0.0, 0.0, 1.0]
        
        return m
    }
    
    static func translate(x: Float, y: Float, z: Float) -> Matrix {
        var m = Matrix()
        m.row3 = [x, y, z, 1.0]
        return m
    }
    
    static func scale(x: Float, y: Float, z: Float) -> Matrix {
        var m = Matrix()
        m.matrix[0] = x
        m.matrix[5] = y
        m.matrix[10] = z
        return m
    }
    
    static func zRotate(radians: Float) -> Matrix {
        let c = cos(radians)
        let s = sin(radians)
        
        var m = Matrix()
        m.row0 = [c, s, 0, 0]
        m.row1 = [-s, c, 0, 0]
        return m
    }
    
    static func yRotate(radians: Float) -> Matrix {
        let c = cos(radians)
        let s = sin(radians)
        
        var m = Matrix()
        m.row0 = [c, 0, -s, 0]
        m.row2 = [s, 0, c, 0]
        return m
    }
    
    
    static func xRotate(radians: Float) -> Matrix {
        let c = cos(radians)
        let s = sin(radians)
        
        var m = Matrix()
        m.row1 = [0, c, -s, 0]
        m.row2 = [0, -s, c, 0]
        return m
    }
    
    static func multiply(m1: Matrix, m2: Matrix) -> Matrix {
        var m = Matrix()
        
        func dot (v1: [Float], v2: [Float]) -> Float {
            return v1[0] * v2[0] + v1[1] * v2[1] + v1[2] * v2[2] + v1[3] * v2[3]
        }
        m.matrix[0] = dot(m1.row0, v2: m2.column0)
        m.matrix[1] = dot(m1.row0, v2: m2.column1)
        m.matrix[2] = dot(m1.row0, v2: m2.column2)
        m.matrix[3] = dot(m1.row0, v2: m2.column3)
        
        m.matrix[4] = dot(m1.row1, v2: m2.column0)
        m.matrix[5] = dot(m1.row1, v2: m2.column1)
        m.matrix[6] = dot(m1.row1, v2: m2.column2)
        m.matrix[7] = dot(m1.row1, v2: m2.column3)
        
        m.matrix[8] = dot(m1.row2, v2: m2.column0)
        m.matrix[9] = dot(m1.row2, v2: m2.column1)
        m.matrix[10] = dot(m1.row2, v2: m2.column2)
        m.matrix[11] = dot(m1.row2, v2: m2.column3)
        
        m.matrix[12] = dot(m1.row3, v2: m2.column0)
        m.matrix[13] = dot(m1.row3, v2: m2.column1)
        m.matrix[14] = dot(m1.row3, v2: m2.column2)
        m.matrix[15] = dot(m1.row3, v2: m2.column3)
        
        return m
    }
    
    // so this function uses a projection matrix that faces the looker looking down the negative z
    func perspectiveMatrix(left: CGFloat, right: CGFloat, bottom: CGFloat, top: CGFloat, near: CGFloat, far: CGFloat) -> [Float] {
        let a = Float((2 * near) / (right - left))
        let b = Float((2 * near) / (top - bottom ))
        
        let c = Float((left + right) / (right - left))
        let d = Float((bottom + top) / (top - bottom))
        let e = Float((near + far) / (near - far))
        
        let f = Float((2 * near * far) / (near - far))
        let array = [a, 0.0, 0.0, 0.0,
            0.0, b, 0.0, 0.0,
            c, d, e, -1.0,
            0.0, 0.0, f, 1.0]
        
        return array
    }
    
    // This works, but coordinates need to be positive or must be used with a translation matrix with positive-Z
    static func superbible7OrthoMatrix(left: CGFloat, right: CGFloat, bottom: CGFloat, top: CGFloat, near: CGFloat, far: CGFloat) -> [Float] {
        let a = 2 / Float(right - left)
        let b = 2 / Float(top - bottom)
        let c = 2 / Float(near - far)
        
        let d = Float((right + left) / (left - right))
        let e = Float((top + bottom) / (bottom - top))
        let f = Float((far + near) / (far - near))
        
        let array: [Float] = [a, 0.0, 0.0, 0.0,
            0.0, b, 0.0, 0.0,
            0.0, 0.0, c, 0.0,
            d, e, f, 1.0]
        
        return array
    }
    
    var count: Int {
        get {
            return matrix.count
        }
    }
    
    var array: [Float] {
        get {
            return matrix
        }
    }
    
    var row0:[Float] {
        get {
            return [matrix[0], matrix[1], matrix[2], matrix[3]]
        }
        set {
            matrix[0] = newValue[0]
            matrix[1] = newValue[1]
            matrix[2] = newValue[2]
            matrix[3] = newValue[3]
        }
    }
    
    
    var row1: [Float] {
        get {
            return [matrix[4], matrix[5], matrix[6], matrix[7]]
        }
        
        set {
            matrix[4] = newValue[0]
            matrix[5] = newValue[1]
            matrix[6] = newValue[2]
            matrix[7] = newValue[3]
        }
    }
    
    var row2: [Float] {
        get {
            return [matrix[8], matrix[9], matrix[10], matrix[11]]
        }
        
        set {
            matrix[8] = newValue[0]
            matrix[9] = newValue[1]
            matrix[10] = newValue[2]
            matrix[11] = newValue[3]
        }
    }
    
    var row3: [Float] {
        get {
            return [matrix[12], matrix[13], matrix[14], matrix[15]]
        }
        
        set {
            matrix[12] = newValue[0]
            matrix[13] = newValue[1]
            matrix[14] = newValue[2]
            matrix[15] = newValue[3]
        }
    }
    
    var column0: [Float] {
        get {
            return [matrix[0], matrix[4], matrix[8], matrix[12]]
        }
        
        set {
            matrix[0] = newValue[0]
            matrix[4] = newValue[1]
            matrix[8] = newValue[2]
            matrix[12] = newValue[3]
        }
    }
    
    var column1: [Float] {
        get {
            return [matrix[1], matrix[5], matrix[9], matrix[13]]
        }
        
        set {
            matrix[1] = newValue[0]
            matrix[5] = newValue[1]
            matrix[9] = newValue[2]
            matrix[13] = newValue[3]
        }
    }
    
    var column2: [Float] {
        get {
            return [matrix[2], matrix[6], matrix[10], matrix[14]]
        }
        
        set {
            matrix[2] = newValue[0]
            matrix[6] = newValue[1]
            matrix[10] = newValue[2]
            matrix[14] = newValue[3]
        }
    }
    
    var column3: [Float] {
        get {
            return [matrix[3], matrix[7], matrix[11], matrix[15]]
        }
        
        set {
            matrix[3] = newValue[0]
            matrix[7] = newValue[1]
            matrix[11] = newValue[2]
            matrix[15] = newValue[3]
        }
    }
    
}


