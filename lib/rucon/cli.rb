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

      basefs_mount = "./fs/mnt/#{base}"
      die "rootfs #{base} not mounted" unless Dir.exists? basefs_mount

      cr = "./containers/#{name}"
      system "mkdir -p #{cr}/rw #{cr}/combined"
      File.write "#{cr}/FS",  base
    end

    desc "enter [NAME]", "Enters a container without booting"
    def enter(name)
      ensure_root!

      cr = "./containers/#{name}"
      die "No container at path #{cmb}, did u create it?" unless Dir.exists? cr

      mount_container name
      system "systemd-nspawn -D #{cr}/combined"
    end

    desc "boot [NAME]", "Boots a container"
    def boot(name)
      ensure_root!
      
      cr = "./containers/#{name}"
      die "No container at path #{cmb}, did u create it?" unless Dir.exists? cr
      
      mount_container name
      system "systemd-nspawn -bD #{cr}/combined"
    end

    private

    def mount_container(name)
      cr = "./containers/#{name}"

      #mount base
      basefs     = File.read "#{cr}/FS"
      mount_path = "./fs/mnt/#{basefs}"
      
      command "mkdir -p #{mount_path}"   
      command "mount -t squashfs fs/store/#{basefs}.sqsh #{mount_path}"

      # mount container
      rw          = "#{cr}/rw"
      combined    = "#{cr}/combined"
      command "mount -t overlayfs overlayfs -olowerdir=#{mount_path},upperdir=#{rw} #{combined}"      
    end

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