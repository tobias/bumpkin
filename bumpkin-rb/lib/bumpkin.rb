require "bumpkin/version"
require 'bumpkin/parser'

module Bumpkin
  class << self
    def run(str)
      Bumpkin.parse(str).evaluate()
    end

    def load(path)
      File.open(path, 'r').read
    end

    def run_file(path)
      run(load(path))
    end
  end
end

