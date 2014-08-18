
app: app.js cache.manifest

app.js: extend-prototype.js main.js notifications.js appcache.js
	cat $+ > app.js

%.js: %.coffee
	coffee --no-header -c $<

cache.manifest:
	echo "CACHE MANIFEST" > $@
	echo "# " `git describe --long --tags` >> $@
	if [ ! -n "$(git status --porcelain)" ]; then echo "# UNCLEAN BUILD " `date +%s` >> $@ ; fi
	echo "" >> $@
	echo "CACHE:" >> $@
	echo "about.css" >> $@
	echo "timeline.css" >> $@
	echo "about/index.html" >> $@
	echo "app.js" >> $@
	echo "appcache.js" >> $@
	echo "bowl-of-soup.png" >> $@
	find fonts vendor -type f >> $@
	echo "index.html" >> $@

dist: app.js cache.manifest
	mkdir -p dist
	-rm -r dist/*
	cp -r about.css timeline.css app.js appcache.js bowl-of-soup.png vendor/ fonts/ index.html dist
	mkdir dist/about
	cp about.html dist/about/index.html
	cp cache.manifest dist/
	git describe --long --tags > dist/VERSION

.PHONY: app cache.manifest dist
