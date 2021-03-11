# 画像のネイティブLazy-loadをサポートするMT7用プラグイン「Native LazyLoad」
img タグにloading 属性(loading="lazy")を自動追加 して、Lazy Load（遅延読み込み）によるウェブページ高速化を支援するMovable Type用プラグインです。 

====

## 概要
- 再構築のタイミングで、img タグ および iframe タグに loading 属性(loading="lazy")を自動追加します。
- img, iframeタグにwidth/height属性が付いているかチェックして、サイズ属性の欠損がある場合は loading="lazy" を付与しません（[CLS](https://support.google.com/webmasters/answer/9205520?hl=ja) の発生を防ぐため）。
- コンテンツ投稿者が、loading属性を明示的に記述している場合は、そちらが優先され、二重に追加されることはありません。
- ブロックタグないしはグローバルモディファイアにより、処理対象をきめ細かく指定できます。
- スタティックパブリッシングに対応。ダイナミックパブリッシングは未対応ですが、ご要望が多ければ将来対応します。
- MT7以降に対応しています。


## 使い方: ブロックタグ

__書式:__
```html
<mt:NativeLazyLoad>
・・・
</mt:NativeLazyLoad>
```

- このタグ内のimgタグ、iframeタグについて以下の処理が行われます。
  - タグに「loading="lazy"」属性が追加される。
  - ただし、すでにloading属性が存在するときは何もしない。
  - また、サイズ属性(width, height）がついていないときも何もしない。
- 処理は再構築のタイミングで行われ、出力結果に対して属性追加がされます。元の投稿内容には変更を加えません。


## 使い方: グローバルモディファイア

__書式:__
```html
native_lazyload="1"
```

__使用例:__
```html
#記事・ウェブページ
<mt:EntryBody native_lazyload="1">
<mt:PageBody native_lazyload="1">
<mt:SomeCustomField native_lazyload="1">

#コンテンツタイプ
<mt:ContentField content_field="画像たっぷりの本文" native_lazyload="1"><mt:ContentFieldValue></mt:ContentField>
<mt:ContentField content_field="レシピ写真" native_lazyload="1"><img src="<mt:AssetURL/>" alt="<mt:AssetLabel/>"></mt:ContentField>
```

- このグローバルモディファイアが付与されたコンテンツについて以下の処理が行われます。
  - imgタグに「loading="lazy"」が追加される
  - ただし、すでにloading属性が存在するときは何もしない。
  - また、サイズ属性(width, height）がついていないときも何もしない。
- 処理は再構築のタイミングで行われ、出力結果に対して属性追加がされます。元の投稿内容には変更を加えません。

## ダウンロード

- https://github.com/ARK-Web/mt-plugin-NativeLazyLoad
- ライセンス: MIT License

## インストール

zipを解凍して [MTNativeLazyLoad] フォルダーごと、MT設置ディレクトリー /plugins にアップロードします。

