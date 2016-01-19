
$(window).load ->
	console.log "loaded"

	$("#login-btn").click (e) ->
		loginForm = $(".card-toplogin")
		loginForm.stop()
		loginForm.slideToggle 800
		$("#mta-widget-login-username").focus()
		e.preventDefault()

	$('.mta-resources-tabs li a[data-toggle="pill"]').on 'shown.bs.tab', (e) ->
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

window.check_user_page_tab = ->
	if window.location.hash
		$('.mta-resources-tabs li a[href='+ window.location.hash+']').tab('show')
