require 'net/http'
require 'uri'

module Lmftfy

  class Forker
    FORK_API = "http://github.com/api/v2/json/repos/fork"
    attr_accessor :username, :password

    def initialize(username, password)
      @username, @password = username, password
    end

    def fork(repo_owner, repo_name)
      uri = URI.parse("#{FORK_API}/#{repo_owner}/#{repo_name}")
      fetch(uri)
    end

    def fetch(uri, limit = 10)
      raise ArgumentError, 'HTTP redirect too deep' if limit == 0

      Net::HTTP.start(uri.host) do |http|
        req = Net::HTTP::Get.new(uri.path)
        req.basic_auth @username, @password
        response = http.request(req)
        case response
        when Net::HTTPSuccess     then response.body
        when Net::HTTPRedirection then fetch(URI.parse(response['location']), limit - 1)
        else
          response.error!
        end
      end
    end
  end
end
