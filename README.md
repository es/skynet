# Skynet

Skynet automatically commits randomly to a specified Git repo through the Github API.

To run Skynet locally:

```
bundle install
GH_REPO=xx/yy GH_ACCESS_TOKEN=xxx ruby main.rb
```

You can see it in action at [es/skynet-test](https://github.com/es/skynet-test).

## Credits

Based on [@mgreensmith](https://github.com/mgreensmith) blog [post](http://mattgreensmith.net/2013/08/08/commit-directly-to-github-via-api-with-octokit/).
