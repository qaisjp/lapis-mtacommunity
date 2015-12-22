
$(window).load ->
	console.log "loaded"

	$("#login-btn").click (e) ->
		loginForm = $(".panel-toplogin")
		loginForm.stop()
		loginForm.slideToggle 800
		e.preventDefault()

window.check_register_validity = (input) ->
	confirm = $("#mta-register-form input[name='password_confirm']")
	confirm[0].setCustomValidity(
		if $("#mta-register-form input[name='password']").val() == confirm.val()
			""
		else
			"Passwords must match"
	)