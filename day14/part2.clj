(deftype recipes-data [scores first second])

(defn matches-at [scores target]
  (case target
    [] (count scores)
    (let [lasts (last scores)
          lastt (last target)]
      (cond
        (= lasts lastt) (recur (drop-last scores) (drop-last target))
        :else -1))))

(defn step [recipes]
  (let [fscore (get (.scores recipes) (.first recipes))
        sscore (get (.scores recipes) (.second recipes))
        sum (+ fscore sscore)
        step_elf (fn [scores i] (rem (+ i (get scores i) 1) (count scores)))]
    (cond
      (< sum 10) (let [scores (conj (.scores recipes) sum)
                       first (step_elf scores (.first recipes))
                       second (step_elf scores (.second recipes))]
                  (->recipes-data scores first second))
      :else (let [scores (conj (.scores recipes) (quot sum 10) (rem sum 10))
                  first (step_elf scores (.first recipes))
                  second (step_elf scores (.second recipes))]
             (->recipes-data scores first second)))))

(defn run [recipes target]
  (let [index1 (matches-at (.scores recipes) target)
        index2 (matches-at (drop-last (.scores recipes)) target)]
    (cond
      (> index1 -1) index1
      (> index2 -1) index2
      :else (recur (step recipes) target))))

(defn compile-target [target]
  (map read-string (clojure.string/split target #"")))

(defn main [target]
  (run (->recipes-data [3, 7] 0 1) (compile-target target)))

(println (main "704321"))
