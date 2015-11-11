require 'octokit'

class Skynet
  REF = 'heads/master'

  def initialize(repo:, access_token:)
    @repo = repo
    @access_token = access_token
  end

  def write(content:, path:, msg: "Committed via Skynet @ #{Time.now.strftime('%e %b %Y %H:%M:%S')}")
    raise ArgumentError.new('Path must be valid filename') unless path.size > 0
    file = get(path)
    options = { sha: file.sha } unless file.nil?

    github.create_content(@repo, path, msg, content, options)
  end

  def delete(path:, msg: "Committed via Skynet @ #{Time.now.strftime('%e %b %Y %H:%M:%S')}")
    raise ArgumentError.new('Path must be valid filename') unless path.size > 0

    file = get(path)
    if file.nil?
      raise ArgumentError.new('File does not exist!')
    else
      github.delete_contents(@repo, path, msg, file.sha)
    end
  end

  private

  def get(path)
    begin
      github.contents(@repo, path: path)
    rescue Octokit::NotFound => e
      puts "#{path} does not exist"
    end
  end

  def github
    @github ||= Octokit::Client.new(access_token: @access_token)
  end
end
