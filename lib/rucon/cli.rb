require 'thor'

module Rucon
  class Cli < Thor

    desc "version", "Shows version information"
    def version
      puts SetEnv::VERSION
    end

    # desc "deps", "install dependenciess"
    # def deps
    #   ['tree']
    # end

    desc "fetchfs [url] [name]", "Fetch a squash fs'ed fs sytem"
    def fetchfs(url, name)
      ensure_root!

      command "mkdir -p fs/store/"
      command "curl #{url} > fs/store/#{name}.sqsh"

      p = "./fs/mnt/#{name}"
      command "mkdir -p #{p}"   
      command "mount -t squashfs fs/store/#{name}.sqsh #{p}"
    end

    desc "mountfs [name]", "Mounts an fs"
    def mountfs(name)
      ensure_root!
      sq = "fs/store/#{name}.sqsh"
      die "#{sq} doesnt exis, did u download it" unless File.exists? sq

      p = "./fs/mnt/#{name}"

      command "mkdir -p #{p}"
      command "mount -t squashfs fs/store/#{name}.sqsh #{p}"
    end

    desc "create [name] [basefs]", "Creates a container from base fs"
    def create(name, base)
      ensure_root!
      p = "./fs/mnt/#{base}"

      die "rootfs #{base} not mounted" unless Dir.exists? p
      puts "Creating container #{name}"

      cmb   = "./containers/#{name}"
      rw    = "./containers/#{name}-rw"
      
      cmd = "mkdir -p #{cmb} #{rw}"

      command "mkdir -p #{cmb} #{rw}"
      command "mount -t overlayfs overlayfs -olowerdir=#{p},upperdir=#{rw} #{cmb}"
    end

    desc "enter [name]", "enters a container"
    def enter(name)
      ensure_root!

      cmb = "./containers/#{name}"
      die "No container at path #{cmb}, dit u create it?" unless Dir.exists? cmb
      cmd = "systemd-nspawn -D #{cmb}"
      system(cmd)
    end

    desc "boot [name]", "enters boots"
    def boot(name)
      ensure_root!
      
      cmb = "./containers/#{name}"
      die "No container at path #{cmb}, dit u create it?" unless Dir.exists? cmb
      cmd = "systemd-nspawn -bD #{cmb}"
      system(cmd)
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