(ns bumpkin-clj.core
  (:refer-clojure :exclude [load])
  (:require [bumpkin-clj.parser :as parser]
            [bumpkin-clj.eval :as eval]))

(defn run [str]
  (->> str parser/parse (eval/eval nil)))

(defn load [file]
  (slurp file))

(defn run-file [file]
  (-> file load run))

(defn -main [& args]
  (doseq [f args]
    (run-file f)))
