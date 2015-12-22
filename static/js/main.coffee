
$(window).load ->
	console.log "loaded"

	$("#login-btn").click (e) ->
		loginForm = $(".panel-toplogin")
		loginForm.stop()
		loginForm.slideToggle 800
		e.preventDefault()
		