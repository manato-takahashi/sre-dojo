AWS_REGION := ap-northeast-1
APP_NAME   := sre-dojo-app
TF_DIR     := terraform

# ECRのURLは terraform output から取得する
ECR_URL = $(shell cd $(TF_DIR) && terraform output -raw ecr_repository_url 2>/dev/null)

# ---- 環境を立ち上げる ----
.PHONY: up
up: deploy

# ---- 環境を壊す ----
.PHONY: destroy
destroy:
	cd $(TF_DIR) && terraform destroy -auto-approve

# ---- 個別ステップ（upの中身を分けて叩きたくなったとき用） ----

.PHONY: init
init:
	cd $(TF_DIR) && terraform init

.PHONY: plan
plan:
	cd $(TF_DIR) && terraform plan

.PHONY: build
build:
	docker build -t $(APP_NAME):latest .

.PHONY: push
push:
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(ECR_URL)
	docker tag $(APP_NAME):latest $(ECR_URL):latest
	docker push $(ECR_URL):latest

.PHONY: deploy
deploy: build
	cd $(TF_DIR) && terraform apply -auto-approve
	$(MAKE) push
