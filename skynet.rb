require 'octokit'

class Skynet
  REF = 'heads/master'

  def initialize(repo:, access_token:)
    @repo = repo
    @access_token = access_token
  end

  def write(content, path, msg="Committed via Skynet @ #{Time.now.strftime('%e %b %Y %H:%M:%S')}")
    raise ArgumentError.new('Path must be valid filename') unless path.size > 0
    blob_sha = github.create_blob(@repo, Base64.encode64(content), 'base64')

    new_tree = github.create_tree(@repo,[{
        path: path,
        mode: '100644',
        type: 'blob',
        sha: blob_sha
      }], {
      base_tree: base_tree.sha
    })

    new_commit = github.create_commit(@repo, msg, new_tree.sha, latest_commit.sha)
    bust_cache
    github.update_ref(@repo, REF, new_commit.sha)
  end

  private

  def latest_commit
    @latest_commit ||= github.ref(@repo, REF).object
  end

  def base_tree
    @base_tree ||= github.commit(@repo, latest_commit.sha).commit.tree
  end

  def bust_cache
    @base_tree = @latest_commit = nil
  end

  def github
    @github ||= Octokit::Client.new(access_token: @access_token)
  end
end
