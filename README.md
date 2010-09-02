# Github Post-receive Hooks Hack #

## Usage ##

1. Copy the example config
1. Point it to your repos
1. Manage your post-receive hooks like you had a script/console in Github

You can also just use it as a library. 

## Reasoning ##

At Engine Yard, we have 100s of repos and many of them are hooked into CI and deployment tools via the hooks.
Managing these is painful and doing an audit of them is even more fun. 

This was built to ease that pain until the devs at Github decide to implement an API for managing these. 
