require './skynet'
require 'yaml'


DIRS = 'skynet'.split('')
CODE_SHA = Octokit::Client.new(access_token: ENV['GH_ACCESS_TOKEN'])
                          .ref('es/skynet', 'heads/master')
                          .object
                          .sha

skynet = Skynet.new(repo: ENV['GH_REPO'], access_token: ENV['GH_ACCESS_TOKEN'])

loop do
  content = {
    'sha' => CODE_SHA,
    'time' => Time.now.to_i
  }.to_yaml.gsub("---\n", '')
  path = "#{DIRS.sample(rand(1..DIRS.size)).join('/')}.yml"

  puts "Writing to #{path}"
  skynet.write(content, path)

  nap_time = rand(1..60)
  puts "Sleeping for #{nap_time}s"
  sleep(nap_time)
end
