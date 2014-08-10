require 'yaml'
require 'starbound_srv_mgr/exceptions'

module StarboundSrvMgr
    class Config

        # @var [Hash]
        @config = {}

        # Initialize the config object with a configuration file or hash.
        #
        # @param [String|Hash] config_source
        # @return [StarboundSrvMgr::Config]
        def initialize(config_source)
            case config_source
                when String
                    unless File.exists? config_source
                        raise StarboundSrvMgr::InvalidConfigSourceError, %q{Config file '%s' could not be found} % [config_source]
                    end

                    raw_config = YAML.load_file config_source
                when Hash
                    raw_config = config_source
                else
                    raise StarboundSrvMgr::InvalidConfigSourceError, %q{Unexpected config source: %s} % [config_source.to_s]
            end

            # Convert all string keys to symbols.
            @config = raw_config.inject({}) do |memo, (key,value)|
                memo[key.to_sym] = value
                memo
            end
        end

        # Get a config value by key.
        #
        # @param [String|Symbol] key
        def get(key)
            key = key.to_sym

            return @config.clone if key == :'::'

            unless @config.has_key? key
                raise StarboundSrvMgr::InvalidConfigKeyError, %q{Config key '%s' not found} % [key]
            end

            @config[key]
        end

        # Alias for #get('::')
        def get_all
            get('::')
        end

    end
end