require 'thor'

module Rucon
  class Cli < Thor

    desc "version", "Shows version information"
    def version
      puts Rucon::VERSION
    end

    desc "fetchfs [URL]", "Fetch a squash fs'ed fs sytem"
    def fetchfs(url)
      ensure_root!

      # download
      name = File.basename(url, ".sqsh")
      command "mkdir -p fs/store/"
      command "curl #{url} > fs/store/#{name}.sqsh"

      # mount
      mountfs name
    end

    desc "mountfs [name]", "Mounts a base filesystem"
    def mountfs(name)
      ensure_root!
      
      p = "./fs/mnt/#{name}"
      command "mkdir -p #{p}"   
      command "mount -t squashfs fs/store/#{name}.sqsh #{p}"
    end

    desc "create [NAME] [BASEFS]", "Creates a container from base fs"
    def create(name, base)
      ensure_root!
      p = "./fs/mnt/#{base}"

      die "rootfs #{base} not mounted" unless Dir.exists? p
      puts "Creating container #{name}"

      cmb   = "./containers/#{name}"
      rw    = "./containers/#{name}-rw"
      
      cmd   = "mkdir -p #{cmb} #{rw}"

      # command "mkdir -p #{cmb} #{rw}"
      # command "mount -t overlayfs overlayfs -olowerdir=#{p},upperdir=#{rw} #{cmb}"
    end

    desc "enter [NAME]", "Enters a container without booting"
    def enter(name)
      ensure_root!

      cmb = "./containers/#{name}"
      die "No container at path #{cmb}, did u create it?" unless Dir.exists? cmb

      system "systemd-nspawn -D #{cmb}"
    end

    desc "boot [NAME]", "Boots a container"
    def boot(name)
      ensure_root!
      
      cmb = "./containers/#{name}"
      die "No container at path #{cmb}, did u create it?" unless Dir.exists? cmb

      system "systemd-nspawn -bD #{cmb}"
    end

    private

    def ensure_root!
      die 'Must run as root' unless Process.uid == 0
    end

    def die(msg)
      puts msg
      exit 1
    end

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