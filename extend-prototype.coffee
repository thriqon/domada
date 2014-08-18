HTMLLIElement.prototype.init = ->
	this.querySelector('.skip-button').addEventListener('click', this.skip.bind(this))
	this.querySelector('.start-button').addEventListener('click', this.start.bind(this))

	@recalculateTargetTime()
	@refreshDisplay()

HTMLLIElement.prototype.start = ->
	return console.warn 'No duration set' unless this.dataset.duration

	@classList.remove 'inactive'
	@recalculateTargetTime()
	@refreshInterval = setInterval @tick.bind(@), 1000
	@refreshDisplay()
	document.dispatchEvent(new CustomEvent('PomodoroPartStarted', detail: {type: @dataset.type}))

HTMLLIElement.prototype.skip = ->
	@finish()

HTMLLIElement.prototype.recalculateTargetTime = ->
	@targetTime = moment().add @dataset.duration, 'minutes'

HTMLLIElement.prototype.refreshDisplay = ->
	remainingSeconds = @targetTime.diff moment(), 'seconds'

	@querySelector('small span').innerHTML = @targetTime.fromNow(true)

	percentDone = 100 - (remainingSeconds / (@dataset.duration * 60))*100
	@querySelector('.progress-bar').style.width = "" + percentDone + "%"

HTMLLIElement.prototype.shouldFinish = ->
	return @targetTime.isBefore moment()

HTMLLIElement.prototype.finish = ->
	clearInterval @refreshInterval
	@moveElementOut()
	document.dispatchEvent(new CustomEvent('PomodoroPartFinished', detail: {type: @dataset.type}))
	@nextSibling.start()

HTMLLIElement.prototype.tick = ->
	@refreshDisplay()
	@finish() if @shouldFinish()

HTMLLIElement.prototype.moveElementOut = ->
	@style.marginTop = -@offsetHeight + 'px'
	setTimeout @remove.bind(@), 500
