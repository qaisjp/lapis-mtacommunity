
$(window).load ->
	console.log "loaded"

	$("#login-btn").click ->
		loginForm = $(".panel-toplogin")
		loginForm.stop()
		loginForm.slideToggle 800
		
