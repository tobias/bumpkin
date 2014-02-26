(ns bumpkin-clj.parser
  (:require [instaparse.core :as insta]))

(def parser
  (insta/parser
    "program = space* (fundef / expr / comment)+
     <space> = <#'[\\s\\t\\n]+'>
     <comment> = #'`.*' space*
     <expr> =  funcall / if / int / sym
     int = #'[0-9]+' space*
     sym = #'[a-zA-Z!@#$%^&*_\\-+=<>?0-9]+' space*
     funcall = sym <'['> args <']'> space*
     args = expr*
     fundef = sym params <':'> body
     params = sym*
     body = space* expr space*
     if = <'('> space* expr <')'> space* expr <'|'> space* expr space*"))

(def transform-opts
  {:int read-string
   :sym (fn [s] [:sym (symbol s)])
   :fundef (fn [[_ name] [_ & params] [_ body]]
             [:fundef name (map second params) body])
   :funcall (fn [fn [_ & args]]
              [:funcall fn args])})

(defn parse [str]
  (insta/transform transform-opts (parser str)))
