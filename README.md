Knowledge Center Update Checker for iOS
============

# Basics:
 - Swift3.0

# Dependencies:
 - Xcode8 or later
 - [Carthage](https://github.com/Carthage/Carthage)

# How to start:

- Install Carthage: `brew install carthage`
- Download Deps: `carthage update`

上記実行後、Xcodeにてプロジェクトを開く

# Traboule shoot

- `carthage`関連でエラーが出た場合には次のようにコマンドを実行するとうまくいく可能性がある

    `carthage update --platform iOS --no-use-binaries`

    - 参考：[Module compiled with swift 3.0 cannot be imported in Swift 3.0.1](http://stackoverflow.com/questions/40250381/module-compiled-with-swift-3-0-cannot-be-imported-in-swift-3-0-1)
