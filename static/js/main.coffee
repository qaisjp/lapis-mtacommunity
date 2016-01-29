
$(window).load ->
	console.log "loaded"

	$("#login-btn").click (e) ->
		loginForm = $(".card-toplogin")
		loginForm.stop()
		loginForm.slideToggle 800
		$("#mta-widget-login-username").focus()
		e.preventDefault()

	$('.mta-tablinks li a[data-toggle="pill"]').on 'shown.bs.tab', (e) ->
		if history.pushState
			history.pushState(null, null, e.target.hash)
		else
			window.location.hash = e.target.hash

window.check_register_validity = (input) ->
	confirm = $("#mta-register-form input[name='password_confirm']")
	confirm[0].setCustomValidity(
		if $("#mta-register-form input[name='password']").val() == confirm.val()
			""
		else
			"Passwords must match"
	)


$(".table-href > tbody > tr").click ->
	# todo: handle middle click & ctrl click
	window.document.location = $(this).data "href"

window.check_tablinks = ->
	if window.location.hash
		$('.mta-tablinks li a[href="'+ window.location.hash+'"]').tab('show')

