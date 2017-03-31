Knowledge Center Update Checker Client for iOS
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

# License management
使用しているライブラリや画像についてはライセンス情報を記載する必要がある。それぞれ次の方法によって対応すること。

- ライブラリの場合

    使用しているライブラリに追加・変更・削除があった場合には次のコマンドにより更新する。

    `swift acknowledgement_generator.swift . ./kcuc/SupportingFiles/Settings.bundle/Acknowledgements.plist`

- 画像の場合

    画像のライセンス情報についてはライブラリのような簡便な方法はないため、手書きで追加・変更・削除を行う。1ライセンスごとに`<dict>`の値を埋める形で記入する。

また、上記によって記入したライセンス情報の確認方法は、シミュレーター等でのアプリ起動後に`Cmd + Shift + H`にてアプリをバックグラウンドへ戻した後に、`Settings`の最下部に表示される`KCUC`から。ライブラリは`Acknowledgements`に、画像は`ImageResources`に表示される。

参考：[CocoaPodsで導入しているライブラリのライセンス表記を自動的に作成する - 24/7 twenty-four seven](http://blog.kishikawakatsumi.com/entry/20140211/1392111037)

# Troubleshooting

- `carthage`関連でエラーが出た場合には対処方法として次の2つが考えられる。

1. `Carthage`ディレクトリを削除する

    `carthage update`実施後に生成される`Carthage`ディレクトリを削除することでビルド済みの内容が削除される。その後、再度`carthage update`あるいは、`carthage checkout`, `carthage build`を実行することで解決する場合がある。

2. `carthage`で利用しているライブラリのアップデートを試みる

    `carthage update --platform iOS --no-use-binaries`によって依存しているライブラリをアップデートする。

- 参考：[Correct framework DWARFs and symbols to workaround broken debugging 🔥 · Issue #924 · Carthage/Carthage · GitHub](https://github.com/Carthage/Carthage/issues/924)
- 参考：[Module compiled with swift 3.0 cannot be imported in Swift 3.0.1](http://stackoverflow.com/questions/40250381/module-compiled-with-swift-3-0-cannot-be-imported-in-swift-3-0-1)
