# Ubuntu 20.04 開発環境セットアップ手順（Windows + Hyper-V）

## 0. 前提条件
- Cドライブに 10GB 以上の空き容量があること

---

## 1. Hyper-V 機能の有効化手順

Windows の Hyper-V 機能が無効になっている場合は、以下の手順で有効化する

1. スタートメニューで「Windows の機能の有効化または無効化」と入力し起動
2. 一覧の中から **「Hyper-V」** にチェックを入れる
   - 「Hyper-V プラットフォーム」と「Hyper-V 管理ツール」両方にチェックが入っていることを確認
3. 「OK」をクリックし、再起動を求められた場合は PC を再起動

---

## 2. 仮想マシンの準備

### Hyper-V マネージャーを起動
1. スタートメニューで "Hyper-V マネージャー" を検索し、起動

### 仮想スイッチの作成
1. 右側の "操作" パネルで [仮想スイッチ マネージャー] をクリック
2. [外部] を選択 → "作成"
3. 名前を **ExternalSwitch** に設定し、使用するネットワークアダプターを選択 → "OK"

### Ubuntu 仮想マシンの作成
1. [操作] → [クイック作成] を選択
2. 「オペレーティングシステムの選択」では **Ubuntu 20.04** を選択
3. 右下の「その他のオプション」を押下し、「Network」に **ExternalSwitch** を選択
4. 「仮想マシンの作成」を押下して作成開始
5. 「仮想マシンが正常に作成されました」と表示されたら、「設定の編集」ボタンを押下し、以下のように設定を変更
   - 左側の「メモリ」を選択
   - RAMを **4096MB（4GB）** に設定
   - 「動的メモリを有効にする」のチェックを外す（固定メモリにする）
   - 適用 → OK
6. 「仮想マシンが正常に作成されました」の画面に戻るので、「接続」ボタンを押下
---

## 3. Ubuntu 初期設定

### 仮想マシンの起動
- 「仮想マシン "Ubuntu20.24 LTS" はオフになっています」の画面で「起動」ボタンを押下、あるいは"Hyper-V マネージャー"で仮想マシンを右クリックして「起動」

### 初期セットアップ
- 表示される画面に従い、以下を設定
  - System Configurationウィンドウで **日本語** を選択し「続ける」ボタンを押下
  - キーボードレイアウトで左から **Japanese** 、右からも**Japanese**を選択し「続ける」ボタンを押下
  - 「どこに住んでいますか？」と聞かれるので **Tokyo** を選択し「続ける」ボタンを押下
  - 「あなたの情報を入力してください」と指示されるので、名前、コンピュータ名、ユーザー名、パスワードを入力し、「自動的にログインする」にチェックを入れて「続ける」ボタンを押下
  - 「Ubuntuへようこそ」と表示される
  - 「画面の設定」のダイアログが表示されるまで待機
  - 「画面の設定」のダイアログを×で閉じる 
  - 「SoftWare Updater」のダイアログには「Remind me later」で応答
  - 「Ubuntu 22.04.5 LTS Upgrade Available」のダイアログには「Don't Upgrade」で応答 
  - 「You have declined the upgrade to Ubuntu 22.04.5 LTS」のダイアログには「OK」で応答
  - 「Online Accounts」のウィンドウは右上の「Skip」を押下
  - 「Livepatch」のウィンドウは右上の「Next」を押下
  - 「Help improve Ubuntu」のウィンドウは「No, don't send system info」を選択し、右上の「Next」を押下 
  - 「Privacy」のウィンドウは右上の「Next」を押下
  - 「You're ready to go!」のウィンドウは右上の「Done」を押下

---

## 4. 基本セッションでの準備
左上の "Activities" を押下し、入力域に「ter」と入力して表示された候補から選んで **Terminal** を起動
### アップデートが可能なパッケージのリストを更新
Terminalにて以下のコマンドを実行
```bash
sudo apt update
```
- 実行中にパスワードを求められたら入力
### Gitのインストール
Terminalにて以下のコマンドを実行
```bash
sudo apt install -y git
```

### GitHub repositoryをclone
Terminalにて以下のコマンドを実行（基本セッションでは、ホストと仮想マシンでコピー＆ペースト不可のため手打ち）
```bash
git clone https://github.com/Widthdom/ubuntu-setup.git
cd ubuntu-setup
```

### `xrdp-xfce-setup.sh` を実行（リモート接続環境の構築）し再起動
Terminalにて以下のコマンドを実行
```bash
chmod +x ./xrdp-xfce-setup.sh
```
Terminalにて以下のコマンドを実行
```bash
./xrdp-xfce-setup.sh
```
上記スクリプトは以下を自動で実行する
- xfce4 デスクトップ環境のインストール
- xrdp + Xvnc の構成
- Wayland 無効化
- リモートデスクトップ用の起動設定

#### スクリプトの処理途中で「lightdm を設定しています」のウィンドウが表示されるのでEnter
#### 「Default display manager」のウィンドウが表示されるので矢印キーでgdm3 → lightdmに変更し、Enter
#### 「システムプログラムの問題が見つかりました」のダイアログにはCancelで応答
```
処理中にエラーが発生しました：
 xrdp
E: Sub-Process /usr/bin/dpkg returned an error code (1)
```
#### 上記エラーは無視
```
After reboot, use 'Xvnc' session when connecting via Remote Desktop.
```

上記が表示されたら、続けて以下のコマンドを実行（再起動）
```bash
sudo reboot
```

---

## 5. 拡張セッションの起動

### Windows 側からリモート接続
- **拡張セッションを開く（Xvnc）**
- 解像度を調整する画面が表示されたら、適当なサイズを選択して接続（表示されない場合は、仮想マシン接続画面左上の「拡張セッション」ボタンを押下）
- 青色の背景のログイン画面が表示されたら、デフォルト「Xorg」となっているプルダウンから「Xvnc」を選び、ユーザ名、パスワードを入力してOKを押下しログイン
- 「System program problem detected」というダイアログにはCancelで応答
- 「Update standard folders to current language?」というウィンドウには「Keep Old Names」で応答

---

## 6. アプリのインストールとショートカット作成
### Xfce Terminal を起動
- 左上の "Applications" メニュー → "System" → **Xfce Terminal** を起動
### ubuntu-setup フォルダ内へ移動
- Xfce Terminalにて以下のコマンドを実行
```bash
cd ~/ubuntu-setup
```

### `install-apps-and-shortcuts.sh` を実行
- Xfce Terminalにて以下のコマンドを実行
```bash
chmod +x ./install-apps-and-shortcuts.sh
```
- Xfce Terminalにて以下のコマンドを実行
```bash
./install-apps-and-shortcuts.sh
```
- 実行中にパスワードを求められたら入力
- 上記スクリプトは以下を自動で実行する
  - OpenVPN, Google Chrome, Visual Studio Codeのインストール
  - Xfce Terminal, gedit（テキストエディタ）, Remmina（リモートデスクトップ）, Firefox, Google Chrome, Visual Studio Codeのショートカットをデスクトップに作成
  - fcitx（日本語入力）の既定設定

### 終了メッセージ
```
Setup complete.
```
と表示されたらセットアップ完了

---
## 7. 日本語入力設定

### Xfce Terminal を起動
- 左上の "Applications" メニュー → "System" → **Xfce Terminal** を起動

### 日本語入力（Mozc）設定
- Xfce Terminalにて以下のコマンドを実行（拡張セッションでは、ホストと仮想マシンでコピー＆ペースト可能）
```bash
fcitx-configtool
```
- 「Input Method Configuration」ウィンドウが開くので、左下の「＋」ボタンを押下
- 「Only Show Current Language」のチェックを外す
- **Mozc Japanese** を選択 → OK
- 「Input Method Configuration」ウィンドウを×ボタンで閉じる
- Ctrl + Space で英語/日本語入力を切り替えられるようになる

---

## 8. 注意事項・補足

### 基本セッションについて
- ホストと仮想マシンでコピー＆ペースト不可
### 拡張セッションについて
- ホストと仮想マシンでコピー＆ペースト可能
- ファイルを右クリックしたときのメニューから「Open With \"Text Editor\"」を実行しても無反応
  - テキストエディタを開いて対象ファイルをドラッグ＆ドロップすることで運用回避可能

### 空き容量について
- 容量が枯渇すると仮想マシンが起動しなくなる
  - 左上の "Application" メニューから Xfce Terminal を起動し、以下のコマンドで空き容量を確認すること
```bash
df -h
```
  - とくにFilesystem='/dev/sda1'のUse%に注意
### サーバとのファイル送受信について
  - File Managerのアドレスバーに以下のように入力することでアクセス可能
```
smb://[サーバのIPアドレス]
```
### 環境を削除する場合
  - Hyper-V マネージャーから仮想マシンを削除
  - 以下に仮想ハードディスクファイル（.vhdx）が残るので削除
```
C:\ProgramData\Microsoft\Windows\Virtual Hard Disks
```