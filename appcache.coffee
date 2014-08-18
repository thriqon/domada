
if window.applicationCache
	window.applicationCache.addEventListener 'updateready', ->
		window.applicationCache.swapCache()
		if confirm("New version available, reload the page now?")
			document.location.reload()
