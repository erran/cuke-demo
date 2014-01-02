require 'cucumber/formatter/io'

class StatsFormatter
  include Cucumber::Formatter::Io
  attr_reader :runtime

  def initialize(runtime, path_or_io, options)
    if path_or_io.is_a? String
      path_or_io = File.expand_path(path_or_io)
    end

    @io = ensure_io(path_or_io, 'cucumber_json')

    @runtime = runtime
    @options = options
  end

  def after_features(features)
    stats = %i[passed failed skipped pending].map { |status|
      {
        status => {
          scenarios: runtime.scenarios(status).count,
          steps: runtime.steps(status).count
        }
      }
    }.inject(:merge) # Merge the hashes for each status together vs. holding an array of them

    @io.puts JSON.pretty_generate(stats)
  end
end
