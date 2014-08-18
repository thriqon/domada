notificationTemplates =
	work:
		title: "Pomodoro"
		body: "It's time to do some work now"
	"short-break":
		title: "Break"
		body: "You worked a lot, take a break now"
	"long-break":
		title: "Longer Break"
		body: "You did it! Another full Pomodoro Set! You really earned your break now."

storedUserEnabledness = ->
	localStorage.usingNotifications == 'true'

storeUserEnabled = ->
	localStorage.usingNotifications = 'true'

toggleUserEnabledness = ->
	localStorage.usingNotifications = storedUserEnabledness() ? "false" : true

refreshNotificationEnabler = ->
	element = document.getElementById 'enable-notifications'
	setIcon = (name) -> element.querySelector('i').setAttribute 'class', 'glyphicon glyphicon-' + name
	setEnablednessTo = (val) -> element.classList.toggle 'disabled', val

	unless window.Notification
		setIcon 'remove'
		setEnablednessTo no
	else
		if Notification.permission == 'denied'
			setIcon 'remove'
			setEnablednessTo no
		else if Notification.permission == 'granted' and storedUserEnabledness()
			setIcon 'check'
			setEnablednessTo yes
		else
			setIcon 'unchecked'
			setEnablednessTo yes

addHandlerForNotificationEnabler = ->
	element = document.getElementById 'enable-notifications'
	element.addEventListener 'click', ->
		if Notification.permission == 'granted'
			toggleUserEnabledness()
			refreshNotificationEnabler()
		else
			Notification.requestPermission (answer) ->
				storeUserEnabled() if answer == 'granted'
				refreshNotificationEnabler()

showNotificationFor = (type) ->
	if storedUserEnabledness() and Notification.permission == 'granted'
		notification = new Notification notificationTemplates[type].title, body: notificationTemplates[type].body, icon: "bowl-of-soup.png"
		notification.onclick = -> notification.close()
		setTimeout (-> notification.close()), 5000

document.addEventListener "DOMContentLoaded", ->
	refreshNotificationEnabler()
	addHandlerForNotificationEnabler()

document.addEventListener "PomodoroPartStarted", (e) ->
	showNotificationFor(e.detail.type)

