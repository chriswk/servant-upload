help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

ghcid:
	ghcid \
		--command "stack ghci upload --ghci-options=-fno-code"

ghcid-test:
	ghcid \
		--command "stach ghci upload:lib upload:test --ghci-options=-fobject-code" \
		-- test "main"

.PHONE: ghcid ghcid-test help

