# Ubuntu 20.04 開発環境セットアップ手順（Windows + Hyper-V）

## 0. 前提条件
- Cドライブに 10GB 以上の空き容量があること

---

## 1. Hyper-V 機能の有効化手順

Windows の Hyper-V 機能が無効になっている場合は、以下の手順で有効化する：

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
2. OS イメージは **Ubuntu 20.04** を選択
3. オプションで仮想スイッチに **ExternalSwitch** を選択
4. 作成後、仮想マシンの [設定] を開き、以下のように設定を変更：
   - [メモリ] タブで、割り当てメモリを **4096MB（4GB）** に設定
   - 「動的メモリを使用する」のチェックを外す（固定メモリにする）
   - 設定を保存して閉じる

---

## 3. Ubuntu 初期設定

### 仮想マシンの起動
- 作成した仮想マシンをダブルクリックして起動

### 初期セットアップ
- 表示される画面に従い、以下を設定：
  - コンピュータ名
  - ユーザー名
  - パスワード
  - 表示言語に **Japanese** を選択

---

## 4. 基本セッションでの準備

### ターミナルを起動して以下を実行
```bash
sudo apt update
sudo apt install -y git
```

### GitHub repositoryをclone
```bash
git clone https://github.com/Widthdom/ubuntu-setup.git
cd ubuntu-setup
```

### `xrdp-xfce-setup.sh` を実行（GUI付きリモート接続環境の構築）
```bash
./xrdp-xfce-setup.sh
```

このスクリプトは以下のことを自動で実行する：
- xfce4 デスクトップ環境のインストール
- xrdp + Xvnc の構成
- Wayland 無効化
- リモートデスクトップ用の起動設定

### 実行後の表示：
```
After reboot, use 'Xvnc' session when connecting via Remote Desktop. Then launch fcitx-configtool and add Mozc.
```

これが表示されたら、以下を実行：
```bash
sudo reboot
```

---

## 5. 拡張セッションの起動と入力設定

### Windows 側からリモート接続
- **拡張セッションを開く（Xvnc）**
- 解像度を調整する画面が表示されたら、適当なサイズを選択
- 青色の背景のログイン画面が表示されたら、デフォルト「Xorg」となっているプルダウンから「Xvnc」を選び、ユーザ名、パスワードを入力してログイン

### xfce Terminal を起動
- 左上の "Application" メニューから **Xfce Terminal** を起動

### 日本語入力（Mozc）設定
```bash
fcitx-configtool
```
- GUIが起動するので、「＋」から **Mozc** を追加 → 適用

---

## 6. アプリのインストールとショートカット作成

### ubuntu-setup フォルダ内へ移動
```bash
cd ~/ubuntu-setup
```

### `install-apps-and-shortcuts.sh` を実行
```bash
./install-apps-and-shortcuts.sh
```

- 実行中にパスワードを求められたら入力
- このスクリプトは以下を自動で実行する：
  - OpenVPN, Google Chrome, Visual Studio Codeのインストール
  - Xfce Terminal, gedit（テキストエディタ）, Remmina（リモートデスクトップ）, Firefox, Google Chrome, Visual Studio Codeのショートカットをデスクトップに作成
  - fcitx（日本語入力）の既定設定

### 終了メッセージ
```
Setup complete.
```
と表示されたらセットアップ完了

---

## 7. 注意事項・補足

- ファイルを右クリックしたときのメニューから「Open With \"Text Editor\"」を実行しても無反応：
  - 対象ファイルをテキストエディタのショートカットへドラッグ＆ドロップして開くことで運用回避可能

- サーバとのファイルの送受信について：
  - FileManagerのアドレスバーに以下のように入力することでアクセス可能：
    ```
    smb://[サーバのIPアドレス]
    ```
- 環境を削除する場合：
  - Hyper-V マネージャーから仮想マシンを削除
  - 以下に仮想ハードディスクファイルが残るので削除する
    ```
    C:\ProgramData\Microsoft\Windows\Virtual Hard Disks
    ```