(function() {
  $(window).load(function() {
    console.log("loaded");
    return $("#login-btn").click(function() {
      var loginForm;
      loginForm = $(".panel-toplogin");
      loginForm.stop();
      return loginForm.slideToggle(800);
    });
  });

}).call(this);
