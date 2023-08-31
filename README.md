# inaba-infra
# フォルダ構成
```
├─env(環境毎の差分吸収)
│  ├─dev
│  └─prod
├─modules(各サービス毎に使う汎用モジュール)
│  └─*
└─services(サービス毎の差分吸収)
    └─*
```

<br>

# 前提条件
* terraform 1.3.4以上がインストールされている
* aws cliがインストールされている
* defulatのawsプロファイルが設定されている

<br>

# インフラ構築
対象環境のディレクトリに移動
```bash
cd ./env/dev
```

terraformコマンド実行

```
terraform init
terrafrom apply
```

しばらく待つと、"本当にインフラ作っちゃっていいの？" って聞かれるので`yes`と入力してEnter!
> Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

<br>

# インフラ破壊
 `init, apply`したディレクトリに移動してdestroyコマンドを発行します

 ```
 terraform destroy
 ```

しばらく待つと、"全部消すけどええんか？"って聞かれるので`yes`を入力してEnter!
> Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.
 
