require 'open-uri'

module Puppet::Parser::Functions
  newfunction(:gitssh_import, :type => :rvalue) do |args|

    if (args.size != 1) then
      raise(Puppet::ParseError, "gitssh_import(): Wrong number of arguments " +
        "given #{args.size} for 1")
    end

    username = args[0]
    
    github_keys = open("https://api.github.com/users/#{username}/keys").read

    return PSON.load(github_keys)

  end
end
