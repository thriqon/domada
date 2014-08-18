
pomodoroSpec = [
	'work', 'short-break', 'work', 'short-break',
	'work', 'short-break', 'work', 'long-break'
]

addNode = (id, cb) ->
	template = document.getElementById(id).content
	clone = document.importNode template, true
	cb(clone) if cb

	timeline = document.getElementById "timeline"
	timeline.appendChild clone
	return clone

generatePomodoroSet = -> pomodoroSpec.forEach((spec) -> addNode(spec + '-node', (node) -> node.querySelector('li').init()))

checkIfShouldGenerateNewSets = -> generatePomodoroSets(3) if shouldGenerateMoreSets()

shouldGenerateMoreSets = -> document.querySelectorAll('.timeline li').length < 20

generatePomodoroSets = (amount) ->
	generatePomodoroSet() while amount -= 1

document.addEventListener "DOMContentLoaded", checkIfShouldGenerateNewSets
document.addEventListener "PomodoroPartFinished", checkIfShouldGenerateNewSets
