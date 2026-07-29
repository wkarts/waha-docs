update-swagger:
	wget http://admin:666@localhost:3000/-json -O - | jq '.' > ./static/swagger/openapi.json
	git add ./static/swagger/openapi.json

changelog-from-plus:
	@cd ../whatsapp-http-api && \
	base=$$(git merge-base core HEAD); \
	if [ -z "$$base" ]; then \
		echo "❌ Could not find common base with 'core'"; \
	else \
		echo "📦 Repository: $$(basename $$PWD)"; \
		echo "🧩 Common base with plus: $$base"; \
		echo; \
		git --no-pager log $$base..HEAD; \
	fi

