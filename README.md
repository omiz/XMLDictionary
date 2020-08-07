# XMLDictionary

useage example:

```swift
let dict: [AnyHashable : Any] = [
    "key1": "value1",
    "key2": 2,
    "key3": true,
    4: "value4",
    "key5": ["foo": "bar"],
    "key6": ["item1", "item 2"]
]

let xml = dict.generateXMLTagsWith(root: "root")

print(xml)
```
```xml
<root><key2>2</key2><4>value4</4><key5><foo>bar</foo></key5><key3>true</key3><key6><element>item1</element><element>item 2</element></key6><key1>value1</key1></root>
```

For a custom value mapping use the protocol `CustomXMLValueConvertible`

```swift
extension Data: CustomXMLValueConvertible {
    
    public var xmlStringValue: String {
        base64EncodedString()
    }
}
```
