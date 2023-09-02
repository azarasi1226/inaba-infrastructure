# Inaba Terraform
# 構成
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
* terraform
* aws cli
* pre-commit
* tflint
* tfdoc

<br>

# インフラ構築方法
対象環境のディレクトリに移動
```bash
cd ./env/dev
```

terraformでの環境構築

```
terraform init
terrafrom apply
```

しばらく待つと、"本当にインフラ作っちゃっていいの？" って聞かれるので`yes`と入力してEnter!
> Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

<br>

# インフラを破壊したい場合
 `init, apply`したディレクトリに移動してdestroyコマンドを発行します

 ```
 terraform destroy
 ```

しばらく待つと、"全部消すけどええんか？"って聞かれるので`yes`を入力してEnter!
> Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

<br>

# 備考
 > なぜInabaと別のRepositoryなの？
 
 リリースライフサイクルが違うから。例えばビジネスロジックコードの変更でCICDかけたいのに、関係ないインフラの変更でCICDかかっちゃったりするから。

 > backend設定でリモートにtfstate管理しないの？
 
 チーム開発しないし、個人的なポートフォリオだからいいかなと...
 