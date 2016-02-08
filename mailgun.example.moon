secrets = require "secrets"
import Mailgun from require "mailgun"
gunner = Mailgun secrets.mailgun
print gunner
result = gunner\send_email {
  to: "me@qaisjp.com"
  subject: "Special SUBJEEECT!"
	html: true
	body: [[
  	<h1>Hello ther!</h1>
    <p>Get Rekt!</p>
    <hr>
    <p>Buh bye!</p>
  ]]
}

print result
