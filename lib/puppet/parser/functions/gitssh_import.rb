require 'open-uri'

module Puppet::Parser::Functions
  newfunction(:gitssh_import, :type => :rvalue) do |args|

    if (args.size != 1) then
      raise(Puppet::ParseError, "gitssh_import(): Wrong number of arguments " +
        "given #{args.size} for 1")
    end

    username = args[0]

    userhash = Hash.new
    Array(username).each do |name|
      github_keys = URI.parse("https://api.github.com/users/#{name}/keys").read

      puppetdata = PSON.load(github_keys)

      userhash[name] = puppetdata
    end

    keyhash = Hash.new
    userhash.each do |_, keys|
      keys.each do |inkey|
        keyhash[inkey['id']] = {'key' => inkey['key']}
      end
    end

    return keyhash

  end
end
