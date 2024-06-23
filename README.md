# 前提条件
* terraform
* aws cli
* pre-commit
* tflint

<br>
<br>

# 準備
## 1. 初期インストール
pre-commitの適応
```
pre-commit install
```

<br>

## 2. Terraform管理外リソース
* Route53のパブリックホストゾーン

<br>
<br>

# インフラ構築
対象環境に移動
```bash
cd ./environments/{対象環境}
```

<br>

terraformコマンド実行
```bash
terraform init \
  -backend-config="profile={tfstateファイルを管理している環境のprofile}"

terrafrom apply
```

<br>

必須情報を入力
```
var.aws_profile
  AWS Profile
```

<br>

しばらく待つと、"本当にインフラ作っちゃっていいの？" って聞かれるので`yes`と入力してEnter
> Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

<br>
<br>

# インフラ破壊
 `init, apply`したディレクトリに移動してdestroyコマンドを発行します

 ```bash
 terraform destroy
 ```

しばらく待つと、"全部消すけどいいの？"って聞かれるので`yes`と入力してEnter
> Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.