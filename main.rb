require './skynet'
require 'yaml'


DIRS = 'skynet'.split('')
CODE_SHA = Octokit::Client.new(access_token: ENV['GH_ACCESS_TOKEN'])
                          .ref('es/skynet', 'heads/master')
                          .object
                          .sha
existing_files = Set.new
skynet = Skynet.new(repo: ENV['GH_REPO'], access_token: ENV['GH_ACCESS_TOKEN'])

def rand_path
  "#{DIRS.sample(rand(1..DIRS.size)).join('/')}.yml"
end

loop do
  path = rand_path
  existing_files.add(path)
  puts "Writing to #{path}"
  skynet.write(
    content: {
      'sha' => CODE_SHA,
      'time' => Time.now.to_i
    }.to_yaml.gsub("---\n", ''),
    path: path,
    msg: "Writing #{path} @ #{Time.now.strftime('%e %b %Y %H:%M:%S')}"
  )

  path = rand_path
  if existing_files.include?(path)
    puts "Deleting #{path}"
    skynet.delete(
      path: path,
      msg: "Deleting #{path} @ #{Time.now.strftime('%e %b %Y %H:%M:%S')}"
    )
    existing_files.delete(path)
  end

  nap_time = rand(1..10)
  puts "Sleeping for #{nap_time}s"
  sleep(nap_time)
end
