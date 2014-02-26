require "bumpkin/version"
require 'bumpkin/parser'
require 'pp'

module Bumpkin
  class << self
    def exec(opts, str)
      iast = Bumpkin.parse(str)
      ast = Bumpkin.transform(iast)
      if opts[:dump]
        puts "Intermediate AST:"
        pp iast
        puts
        puts "Transformed AST:"
        pp ast
        puts
      end
      ast.evaluate()
    end

    def load(path)
      File.open(path, 'r').read
    end

    def run_file(opts, path)
      exec(opts, load(path))
    end

    def run(opts, paths)
      if code = opts[:exec]
        exec(opts, code)
      end

      paths.each do |p|
        run_file(opts, p)
      end
    end
  end
end

