# Machina

_a god introduced by means of a crane in ancient Greek and Roman drama to decide the final outcome_

![](https://theatricaleffectsandstaging.files.wordpress.com/2016/05/untitled1.png?w=390&h=326)

```ruby
fsm = Machina.new(:unconfirmed)

fsm.when[:welcome_email] = -> { send_welcome_email }
fsm.when[:enable_account] = -> (user) { user.enabled! }

fsm[:confirm] = {
  :unconfirmed => [:welcome_email, :enable_account, :confirmed],
}

fsm.state # => :unconfirmed
fsm.trigger!(:confirm, user)
fsm.state # => :confirmed
```
