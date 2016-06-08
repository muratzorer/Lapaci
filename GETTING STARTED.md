# HUBOT - HEROKU - SLACK INTEGRATION (WINDOWS LOCAL)

You will need [node.js and npm](https://nodejs.org). Then [update npm](https://github.com/felixrieseberg/npm-windows-upgrade)
(For Windows users, run npm commands from the Command Prompt (cmd.exe) or PowerShell, not Node.Js (node.exe). 
So your "normal shell" is cmd.exe/PowerShell)
To run PowerShell as Administrator, click Start, search for PowerShell, right-click PowerShell and select Run as Administrator:

	% Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force
	% npm install --global --production npm-windows-upgrade
	% npm-windows-upgrade


Once those are installed, we can install the hubot generator:

    %  npm install -g yo generator-hubot

This will give us the hubot yeoman generator. Now we can make a new directory, and generate a new instance of hubot in it. For example, if we wanted to make a bot called myhubot:

	% mkdir myhubot
	% cd myhubot
	% yo hubot
		
At this point, you'll be asked a few questions about who is creating the bot,
and which [adapter](https://hubot.github.com/docs/adapters/) you'll be using. Adapters are hubot's
way of integrating with different chat providers. (Pick "slack")

Now, you are ready to test locally(with default "shell" adapter):

	% bin/hubot -a shell
	Hubot>

Now we are going to create a new remote private repo for our Hubot development. Then in the local work directory, create local repository and push to remote:

	% git init
	% git add .
	# Adds the files in the local repository and stages them for commit. To unstage a file, 
	use 'git reset HEAD YOUR-FILE'.
	% git commit -m "Initial commit"
	# Commits the tracked changes and prepares them to be pushed to a remote repository. To remove this commit 
	and modify the file, use 'git reset --soft HEAD~1' and commit and add the file again.
	% git remote add origin <remote repository URL>
	# Sets the new remote
	% git remote -v
	# Verifies the new remote URL
	
Lastly, check the package.json for "hubot-slack". If not exists:

	% npm install hubot-slack --save

	
	
## Heroku Deployment

This is a modified set of instructions based on the [instructions on the Hubot wiki](https://github.com/github/hubot/blob/master/docs/deploying/heroku.md).

Install [heroku toolbelt](https://toolbelt.heroku.com/) if you haven't already.

Run the following commands on PowerShell:

	% heroku create coderstage-hubot
	https://coderstage-hubot.herokuapp.com/ | https://git.heroku.com/coderstage-hubot.git
	% heroku addons:create rediscloud:30
	# 30mb is the lowest plan, and the only [free plan](https://elements.heroku.com/addons/rediscloud).
	
Now, activate the Hubot service on your ["Team Services"](http://my.slack.com/services/new/hubot) page inside Slack.
Then, add the config variables. For example:

	% heroku config:add HEROKU_URL=https://my-company-slackbot.herokuapp.com
	% heroku config:add HUBOT_SLACK_TOKEN=xoxb-1234-5678-91011-00e4dd

[Git remotes](https://git-scm.com/book/en/v2/Git-Basics-Working-with-Remotes) are references to remote repositories. You can have any number of these.
Now we will [add new remote for Heroku](https://devcenter.heroku.com/articles/git#tracking-your-app-in-git).

	% heroku git:remote -a coderstage-hubot
	# Git remote heroku added.

The remote is named `heroku` in this example.
There is one special remote name: `origin`, which is the default for pushes. Using origin as the remote name will allow you to type just `git push` instead of `git push heroku`, but we recommend using an explicitly named remote.

Now, just deploy!

	% git push heroku master
	Initializing repository, done.
	updating 'refs/heads/master'
	...


## Heroku KeepAlive Configuration

> There is one special environment variable for Heroku. The default hubot Procfile marks the process as a 'web' process type, in order to support serving http requests (more on that in the scripting docs). The downside of this is that dynos will idle after an hour of inactivity. That means your hubot would leave after an hour of idle web traffic, and only rejoin when it does get traffic. This is extremely inconvenient since most interaction is done through chat, and hubot has to be online and in the room to respond to messages. To get around this, there's a special environment variable to make hubot regularly ping itself over http.

hubot-heroku-keepalive is a built in script comes with default Hubot npm packages. It is a hubot script that keeps the hubot Heroku web dyno alive. Dont forget to apply the configurations to Heroku app:

hubot-heroku-keepalive is configured by four environment variables:

* `HUBOT_HEROKU_KEEPALIVE_URL` - required, the complete URL to keepalive, including a trailing slash.
* `HUBOT_HEROKU_WAKEUP_TIME` - optional,  the time of day (HH:MM) when hubot should wake up.  Default: 6:00 (6 am)
* `HUBOT_HEROKU_SLEEP_TIME` - optional, the time of day (HH:MM) when hubot should go to sleep. Default: 22:00 (10 pm)
* `HUBOT_HEROKU_KEEPALIVE_INTERVAL` - the interval in which to keepalive, in minutes. Default: 5

You *must* set `HUBOT_HEROKU_KEEPALIVE_URL` and it *must* include a trailing slash – otherwise the script won't run. 
You can find out the value for this by running `heroku apps:info`. Copy the `Web URL` and run:

```
heroku config:set HUBOT_HEROKU_KEEPALIVE_URL=PASTE_WEB_URL_HERE
```

If you want to trust a shell snippet from the Internet, here's a one-liner:

```
heroku config:set HUBOT_HEROKU_KEEPALIVE_URL=$(heroku apps:info -s | grep web-url | cut -d= -f2)
```

`HUBOT_HEROKU_WAKEUP_TIME` and `HUBOT_HEROKU_SLEEP_TIME` define the waking hours - between these times the keepalive will ping your Heroku app.  Outside of those times, the ping will be suppressed, allowing the dyno to shut down. These times are based on the timezone of your Heroku application which defaults to UTC.  You can change this with:

```
heroku config:add TZ="America/New_York"
```


## Slack Customization

https://api.slack.com/custom-integrations


## Hubot Customization

You almost definitely will want to change your hubot's name to add character. bin/hubot takes a --name:

% bin/hubot --name myhubot
myhubot>


## References

https://hubot.github.com/docs/
https://github.com/slackhq/hubot-slack
https://github.com/github/hubot/blob/master/docs/deploying/heroku.md
https://github.com/felixrieseberg/npm-windows-upgrade
