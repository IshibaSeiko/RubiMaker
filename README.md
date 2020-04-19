# RubiMaker
入力したテキストのルビを生成するアプリです。

[![Language](https://img.shields.io/badge/language-Swift%205.0-orange.svg)](https://swift.org)

## 開発環境
|項目|バージョン|
|---|---|
|Xcode|11.4+|
|iOS|13.0+|

## 使用API
[goo ラボ ひらがな化API](https://labs.goo.ne.jp/api/jp/hiragana-translation/)

## 使用ライブラリ
ライブラリはSwiftPMによって導入しています。
- 通信
  - [Alamofire](https://github.com/Alamofire/Alamofire)
    API通信に使用
- ネットワーク監視
  - [Reachability](https://github.com/ashleymills/Reachability.swift)
    現在使用していないが、今後の機能拡充のためにインストール済み
- データベース
  - [Realm](https://github.com/realm/realm-cocoa)
    履歴保存のために使用
- ログ
  - [XCGLogger](https://github.com/DaveWoodCom/XCGLogger)
    デバッグ時のログ表示のため使用
- UI
  - [FloatingPanel](https://github.com/SCENEE/FloatingPanel)
    入力画面表示のために使用
  - [GrowingTextView](https://github.com/KennethTsang/GrowingTextView)
    テキストビューのデザインを実現するために使用

## 工夫した点
- APIで定義されたエラーを網羅するように実装
- 直感的に操作できるUI
- かな/カナ切り替え機能
- 変換テキストコピー機能
- 履歴機能、お気に入り登録機能、削除機能

## 今後の課題
- realm-cocoaによる大量のwarningの改善
- 通信切断時の機能拡充
    - 通信切断中、入力したテキストが過去に変換されていた場合はDBから変換後テキストを取得
- カメラや写真から取得したテキストを変換する機能の追加
    - 漢字が読めない -> 入力できないと考えられるため、アプリの使用目的として必要
- 履歴機能の活用
    - 詳細画面への遷移、お気に入り・削除機能の拡充
