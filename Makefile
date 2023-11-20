feature:
	sh scripts/gen-clean-code.sh $(name)

template: 
	./scripts/gen-code-template.sh $(feature) $(layer) $(name)
