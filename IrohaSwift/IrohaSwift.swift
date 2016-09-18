//
//  IrohaSwift.swift
//  IrohaSwift
//
//  Created by Kaji Satoshi on 2016/09/18.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation

public func createSeed() -> Array<UInt8> {
    var seed: Array<UInt8> = Array(repeating: 0, count: 32)
    ed25519_create_seed(&seed)
    
    return seed
}

public func createKeyPair() -> (publicKey:String, privateKey:String){
    var pub: Array<UInt8> = Array(repeating: 0, count: 32)
    var pri: Array<UInt8> = Array(repeating: 0, count: 64)
    var seed: Array<UInt8> = createSeed()
    ed25519_create_keypair(&pub, &pri, &seed)
    let encPub = base64_encode(pub, UInt32(pub.count))
    let base64Pub = String(validatingUTF8:UnsafePointer<CChar>(encPub!))!
    let encPri = base64_encode(pri, UInt32(pri.count))
    let base64Pri = String(validatingUTF8:UnsafePointer<CChar>(encPri!))!
    
    return (base64Pub, base64Pri)
}

public func sign(_ publicKey:String,privateKey:String, message:String) -> String{
    var sig: Array<UInt8> = Array(repeating: 0, count: 64)
    var sigMsg: Array<UInt8> = Array(repeating: 0, count: 32)
    sha3_256(Array<UInt8>(message.utf8), Array<UInt8>(message.utf8).count, &sigMsg)
    var decPubArr = base64toArr(publicKey, count: 32)
    var decPriArr = base64toArr(privateKey, count: 64)
    ed25519_sign(&sig, &sigMsg, sigMsg.count, &decPubArr, &decPriArr)
    let encSig = base64_encode(sig, UInt32(sig.count))
    let base64Sig = String(validatingUTF8:UnsafePointer<CChar>(encSig!))!
    
    return base64Sig
}

public func verify(_ publicKey:String, signature:String, message:String) -> Int{
    var sigMsg: Array<UInt8> = Array(repeating: 0, count: 32)
    sha3_256(Array<UInt8>(message.utf8), Array<UInt8>(message.utf8).count, &sigMsg)
    let decPubArr = base64toArr(publicKey, count: 32)
    let decSigArr = base64toArr(signature, count: 64)
    
    return Int(ed25519_verify(decSigArr, sigMsg, sigMsg.count, decPubArr))
}

func base64toArr(_ base64str:String, count:Int) -> Array<UInt8>{
    let base64Ptr = UnsafeMutablePointer<Int8>(mutating: (base64str as NSString).utf8String)
    let decBase64 = base64_decode(base64Ptr)
    let decArr = Array<UInt8>(UnsafeBufferPointer(start: decBase64, count: count))
    base64Ptr?.deinitialize()
    
    return decArr
}

public func connection(){}

public func getAsset(){}

public func assetTransfar(){}

public func createAsset(){}

public func getTransaction(){}

public func getAllTransaction(){}
