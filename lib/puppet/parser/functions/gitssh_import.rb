require 'net/http'

module Puppet::Parser::Functions
  newfunction(:gitssh_import, :type => :rvalue) do |args|

    if (args.size != 4) then
      raise(Puppet::ParseError, "gitssh_import(): Wrong number of arguments " +
        "given #{args.size} for 4")
    end

    #Function accepts an array of usernames as input
    local_name   = args[0]
    github_user  = args[1]
    github_token = args[2]
    username     = args[3]

    #Loop through list of usernames to read key data from github
    userhash = Hash.new
    Array(username).each do |name|

      # Build github API URI/auth
      github_url = URI("https://api.github.com/users/#{name}/keys")

      github_uri         = Net::HTTP.new(github_url.host, github_url.port)
      github_uri.use_ssl = true

      # Github response
      github_req      = Net::HTTP::Get.new(github_url.request_uri)
      github_req.basic_auth github_user, github_token

      github_response = github_uri.request(github_req)

      # Load in puppet data from github
      puppetdata = PSON.load(github_response.body)

      #Do at least a basic sanity check of output from github
      if ! puppetdata.is_a?(Array) then
        raise(Puppet::ParseError, "Invalid input received for githubkeys for user: #{name}")
      end

      userhash[name] = puppetdata
    end

    #Split usernames from keys and push to a final hash which puppet create_resources can use
    keyhash = Hash.new
    userhash.each do |user, keys|
      keys.each do |inkey|
        #Split the ssh type from the key so puppet can process correctly
        splitkey = inkey['key'].split(" ")
        gitusername = [local_name,user,inkey['id']].join('-')

        keyhash[gitusername] = {'key' => splitkey[1], 'type' => splitkey[0]}
      end
    end

    return keyhash

  end
end
