.PHONY: tags watch-tags clean-tags

tags:
	@$${HOME}/scripts/gen-tags.sh

# Live rebuild on change (requires `entr`: sudo apt-get install entr)
watch-tags:
	@git ls-files -co --exclude-standard | entr -r $${HOME}/scripts/gen-tags.sh

clean-tags:
	rm -f .tags .tags.json .tags.tmp .ctags.files
