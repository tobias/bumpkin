(ns bumpkin-clj.eval
  (:refer-clojure :exclude [eval]))

(defonce global-env
  (atom
    {'-     (fn [_ a b] (- a b))
     'print (fn [_ & args] (apply println args))}))

(defmulti eval (fn [_ x] (if (coll? x) (first x))))

(defmethod eval :default [_ expr]
  expr)

(defmethod eval :sym [env [_ sym]]
  (env sym))

(defmethod eval :fundef [_ [_ name params body]]
  (swap! global-env assoc name
    (fn [env & args]
      (eval (merge env (zipmap params args)) body))))

(defmethod eval :funcall [env [_ fn args]]
  (let [local-env (merge @global-env env)]
    (apply (eval local-env fn)
      local-env
      (map (partial eval local-env) args))))

(defmethod eval :if [env [_ cond iff else]]
  (if (not= 0 (eval env cond))
    (eval env iff)
    (eval env else)))

(defmethod eval :program [_ [_ & program]]
  (last (mapv (partial eval @global-env) program)))

