require 'ostruct'
require 'pp'

class ::OpenStruct
  def pretty_print(pp)
    pp.pp_hash(self.to_h)
  end
end

module Bumpkin
  GLOBAL_ENV = {
    :"-" => lambda {|_, a, b| a - b},
    :print => lambda {|_, *args| puts(*args)}
  }

  class ::Integer
    def evaluate(_)
      self
    end
  end
    
  class ::Symbol
    def evaluate(env)
      env[self]
    end
  end

  # {cond: cond_expr, tbranch: true_expr, fbranch: false_expr}
  class If < OpenStruct
    def evaluate(env)
      if cond.evaluate(env) != 0
        tbranch.evaluate(env)
      else
        fbranch.evaluate(env)
      end
    end
  end

  # {name: sym, body: body_expr, params: [param1, param2, ...]}
  class Fundef < OpenStruct
    def evaluate(env)
      GLOBAL_ENV[name] = lambda do |env, *args|
        body.evaluate(env.clone.merge(Hash[params.zip(args)]))
      end
    end
  end

  # {fn: fn_sym, args: [arg_expr1, arg_expr2, ...]}
  class Funcall < OpenStruct
    def evaluate(env)
      local_env = GLOBAL_ENV.clone.merge(env)
      fn.evaluate(local_env).call(local_env,
                                  *(args.map { |arg|
                                      arg.evaluate(local_env)
                                    }))
    end
  end

  # {program: [expr1, expr2, ...]}
  class Program < OpenStruct
    def evaluate()
      program.map { |expr| expr.evaluate(GLOBAL_ENV) }.last
    end
  end
end
