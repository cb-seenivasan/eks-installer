.PHONY: setup
setup:
	@./scripts/setup.sh

.PHONY: teardown
teardown:
	@./scripts/teardown.sh

.PHONY: codefresh-save-tfstate
codefresh-save-tfstate:
	@sed -i '' "s/TFSTATE_BASE64:.*/TFSTATE_BASE64: \"$$(cat terraform/terraform.tfstate | base64)\"/g" eks-install-context.yaml
	@codefresh patch context -f eks-install-context.yaml

.PHONY: codefresh-load-tfstate
codefresh-load-tfstate:
	@set -o pipefail; codefresh get context eks-install -o json | jq -r '.spec.data.TFSTATE_BASE64' | sed -e 's/^null$$//' | base64 -d > terraform/terraform.tfstate

.PHONY: codefresh-remove-tfstate
codefresh-remove-tfstate:
	@codefresh delete context eks-install
