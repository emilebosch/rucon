require 'thor'
require 'YAML'
require 'hashdiff'
require 'pp'

module Rucon
	class Cli < Thor

    desc "version", "Shows version information"
    def version
      puts SetEnv::VERSION
    end

    private

    def command(cmd)
      env = {'PATH' => ENV['PATH'], 'HOME' => ENV['HOME']}
      rd, wr = IO.pipe
      pid = fork do
        rd.close
        $stdout.reopen(wr)
        exec(env, cmd, :unsetenv_others=>true)         
      end

      wr.close
      Process.waitpid(pid)
      rd.read
    end

    def gem_dir
      File.dirname(File.dirname(File.dirname(__FILE__)))
    end
	end
end