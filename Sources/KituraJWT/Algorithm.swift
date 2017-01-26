/**
 * Copyright IBM Corporation 2017
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Cryptor
import Foundation

// MARK Algorithm

/// The algorithm used to encode the token.
public enum Algorithm {
    /// RSA 256 bits with its key and key type.
    case rs256(Data, RSAKeyType)

    /// RSA 384 bits with its key and key type.
    case rs384(Data, RSAKeyType)

    /// RSA 512 bits with its key and key type.
    case rs512(Data, RSAKeyType)
    
    
    /// A list of possible results of call to isSupported method.
    public enum Supported {
        /// The algorithm is not supported
        case unsupported
        
        /// The algorithm is supported and requires a key or a certifcate.
        case supportedWithKey
        
        /// The algorithm is supported and requires a secret.
        case supportedWithSecret
    }
    
    /// The name of the algorithm.
    public var name: String {
        switch self {
        case .rs256:
            return "RS256"
        case .rs384:
            return "RS384"
        case .rs512:
            return "RS512"
        }
    }
    
    func sign(_ input: String) -> Data? {
        return encryptionAlgortihm.sign(input)
    }
    
    func verify(signature: Data, for input: String) -> Bool {
        return encryptionAlgortihm.verify(signature: signature, for: input)
    }
    
    var encryptionAlgortihm: EncryptionAlgorithm {
        switch self {
        case .rs256(let key, let type):
            return RSA(key: key, keyType: type, algorithm: .sha256)
        case .rs384(let key, let type):
            return RSA(key: key, keyType: type, algorithm: .sha384)
        case .rs512(let key, let type):
            return RSA(key: key, keyType: type, algorithm: .sha512)
        }
    }
    
    /// Return an algorithm for its name and key.
    ///
    /// - Parameter name: The name of the algorithm.
    /// - Parameter key: A Data containing the key.
    /// - Parameter keyType: The type of the key argument: public/private key or certificate.
    /// - Returns: An instance of Algorithm if the input arguments correspond to a supported algorithm.
    public static func from(name: String, key: Data, keyType: RSAKeyType = .publicKey) -> Algorithm? {
        if name == "RS256" || name == "rs256" {
            return .rs256(key, keyType)
        }
        if name == "RS384" || name == "rs384" {
            return .rs384(key, keyType)
        }
        if name == "RS512" || name == "rs512" {
            return .rs512(key, keyType)
        }
        return nil
    }
    
    /// Return an algorithm for its name and secret.
    ///
    /// - Parameter name: The name of the algorithm.
    /// - Parameter secret: A String containing the secret.
    /// - Returns: An instance of Algorithm if the input arguments correspond to a supported algorithm.
    public static func from(name: String, secret: String) -> Algorithm? {
        return nil
    }

    /// Check if an algorithm specified by the name is supported and what input it requires (a key or a secret).
    ///
    /// - Parameter name: The name of the algorithm.
    /// - Returns: A value of `Supported` enum indicating the result.
    public static func isSupported(name: String) -> Supported {
        if name == "RS256" || name == "rs256"
            || name == "RS384" || name == "rs384"
            ||  name == "RS512" || name == "rs512" {
            return .supportedWithKey
        }
        return .unsupported
    }
}