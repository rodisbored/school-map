config_template = ERB.new File.new('config/config.yml').read
CONFIG = YAML.load(config_template.result)[Rails.env].with_indifferent_access
