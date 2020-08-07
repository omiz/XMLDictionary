import Foundation

public protocol CustomXMLValueConvertible {
    var xmlStringValue: String { get }
}

extension CustomXMLValueConvertible where Self: CustomStringConvertible {
    var xmlStringValue: String { description }
}

public protocol CustomXMLTagConvertible {
    func generateXMLTagsWith(root tag: String) -> String
}

public extension CustomXMLTagConvertible where Self: CustomXMLValueConvertible {
    
    func generateXMLTagsWith(root tag: String) -> String {
        makeXMLTag(tag, value: xmlStringValue)
    }
}

extension Data: CustomXMLValueConvertible {
    
    public var xmlStringValue: String {
        base64EncodedString()
    }
}


func makeXMLTag(_ key: AnyHashable, value: Any?) -> String {
    
    let stringKey = String(describing: key)
    
    func tag(_ value: String) -> String {
        return "<\(stringKey)>\(value)</\(stringKey)>"
    }
    
    switch value {
        case let c as CustomXMLValueConvertible:
            return tag(c.xmlStringValue)
        case let d as Dictionary<AnyHashable, Any>:
            return d.generateXMLTagsWith(root: stringKey)
        case let s as Set<AnyHashable>:
            return s.generateXMLTagsWith(root: stringKey)
        case let a as Array<Any>:
            return a.generateXMLTagsWith(root: stringKey)
        case .none:
            return tag("")
        case .some(let value):
            return tag(String(describing: value))
    }
}

extension NSDictionary: CustomXMLTagConvertible, CustomXMLValueConvertible {
    
    public var xmlStringValue: String {
        reduce(into: String(), {
            
            let tag = String(describing: $1.key)
            
            $0 += makeXMLTag(tag, value: $1.value)
        })
    }
}


extension NSArray: CustomXMLValueConvertible, CustomXMLTagConvertible {
    
    public var xmlStringValue: String {
        reduce(into: String(), {
            $0 += makeXMLTag("element", value: $1)
        })
    }
}

public extension KeyValuePairs {
    
    func generateXMLTagsWith(root tag: String) -> String {
        return makeXMLTag(tag, value: xmlStringValue)
    }
    
    var xmlStringValue: String {
        reduce(into: String(), {
            
            let tag = String(describing: $1.key)
            
            $0 += makeXMLTag(tag, value: $1.value)
        })
    }
}

public extension Dictionary {
    
    func generateXMLTagsWith(root tag: String) -> String {
        return makeXMLTag(tag, value: xmlStringValue)
    }
    
    var xmlStringValue: String {
        reduce(into: String(), {
            
            let tag = String(describing: $1.key)
            
            $0 += makeXMLTag(tag, value: $1.value)
        })
    }
}

public extension Sequence where Iterator.Element == (key: AnyHashable, value: Any) {
    
    func generateXMLTagsWith(root tag: String) -> String {
        return makeXMLTag(tag, value: xmlStringValue)
    }
    
    var xmlStringValue: String {
        reduce(into: String(), {
            
            let tag = String(describing: $1.key)
            
            $0 += makeXMLTag(tag, value: $1.value)
        })
    }
}

public extension Collection {
    
    func generateXMLTagsWith(root tag: String) -> String {
        return "<\(tag)>\(xmlStringValue)</\(tag)>"
    }
    
    var xmlStringValue: String {
        reduce(into: String(), {
            
            $0 += makeXMLTag("element", value: $1)
        })
    }
}
