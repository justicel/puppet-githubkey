require 'open-uri'

module Puppet::Parser::Functions
  newfunction(:gitssh_import, :type => :rvalue) do |args|

    if (args.size != 1) then
      raise(Puppet::ParseError, "gitssh_import(): Wrong number of arguments " +
        "given #{args.size} for 1")
    end

    #Function accepts an array of usernames as input
    username = args[0]

    #Loop through list of usernames to read key data from github
    userhash = Hash.new
    Array(username).each do |name|
      github_keys = URI.parse("https://api.github.com/users/#{name}/keys").read

      puppetdata = PSON.load(github_keys)

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
        gitusername = [user,inkey['id']].join('-')

        keyhash[gitusername] = {'key' => splitkey[1], 'type' => splitkey[0]}
      end
    end

    return keyhash

  end
end
