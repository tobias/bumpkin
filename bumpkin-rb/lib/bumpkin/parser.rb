require 'parslet'
require 'parslet/convenience'
require 'bumpkin/nodes'

module Bumpkin
  class Parser < Parslet::Parser
    rule(:program) { space? >> (fundef | expr | comment).repeat
        .as(:program) }
    rule(:comment) { space? >> str('`') >> match('[^\n]')
        .repeat >> space? }
    rule(:space)   { match('\s').repeat(1) }
    rule(:space?)  { space.maybe }
    rule(:expr)    { funcall | int | sym | iff }
    rule(:int)     { match['0-9'].repeat(1).as(:int) >> space? }
    rule(:sym)     { match['a-zA-Z!@#$%^&*_\-+=<>?0-9'].repeat(1)
        .as(:sym) >> space? }
    rule(:funcall) { (sym.as(:fn) >> str('[') >>
                      expr.repeat.as(:args) >> str(']'))
        .as(:funcall) >> space? }
    rule(:fundef)  { (sym.as(:name) >> sym.repeat.as(:params) >>
                      str(':') >> space? >> expr.as(:body))
        .as(:fundef) >> space? }
    rule(:iff)     { (str('(') >> space? >>
                      expr.as(:cond) >> str(')') >> space? >>
                      expr.as(:tbranch) >> str('|') >> space? >> expr
                        .as(:fbranch)).as(:iff) }
    
    root :program
  end

  class Transform < Parslet::Transform
    rule(int: simple(:x))      { x.to_i }
    rule(sym: simple(:x))      { x.to_sym }
    rule(iff: subtree(:x))     { If.new(x) }
    rule(fundef: subtree(:x))  { Fundef.new(x) }
    rule(funcall: subtree(:x)) { Funcall.new(x) }
    rule(program: subtree(:x)) { Program.new(program: x) }
  end

  def self.parse(str)
    Transform.new.apply(Parser.new.parse_with_debug(str))
  end
end
