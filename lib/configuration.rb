# encoding: utf-8

module Configuration
  def config
    Configuration.config
  end

  def self.config
    @config
  end

  def defaultLinks
    Configuration.defaultLinks
  end

  def self.defaultLinks
    @defaultLinks
  end

  def self.read_config location, local
    Configuration.read_configuration location, local
    Configuration.read_default_links
  end

  def self.read_configuration location, local
    raise "Not a valid Web Log Today location" unless self.valid_location? location
    @config = YAML.load File.open(File.join(location, 'config.yaml'), 'r:utf-8').read
    @config["__site_url__"] = @config["site_url"]
    @config["site_url"] = "http://localhost:4000" if local
    @config["path"] = location
  end

  def self.read_default_links
    @defaultLinks = if File.exists? self.links_file_path then "\n" + File.open(self.links_file_path, "r:utf-8").read else "" end
  end

  def self.valid_location? location
    return false unless File.exists? File.join location, "config.yaml"
    return false unless File.directory? File.join location, "_posts"
    return false unless File.directory? File.join location, "_pages"
    return false unless File.directory? File.join location, "_layouts"
    return true
  end

  def self.links_file_path
    File.join config['path'], "links.md"
  end
end
