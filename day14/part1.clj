(deftype recipes_data [scores first second])

(defn step [recipes]
  (let [fscore (get (.scores recipes) (.first recipes))
        sscore (get (.scores recipes) (.second recipes))
        sum (+ fscore sscore)
        step_elf (fn [scores i] (rem (+ i (get scores i) 1) (count scores)))]
    (cond
      (< sum 10) (let [scores (conj (.scores recipes) sum)
                       first (step_elf scores (.first recipes))
                       second (step_elf scores (.second recipes))]
                  (->recipes_data scores first second))
      :else (let [scores (conj (.scores recipes) (quot sum 10) (rem sum 10))
                  first (step_elf scores (.first recipes))
                  second (step_elf scores (.second recipes))]
             (->recipes_data scores first second)))))

(defn run [recipes loops]
  (case loops
    0 recipes
    (recur (step recipes) (- loops 1))))

(defn main [loops]
  (let [data (run (->recipes_data [3, 7] 0 1) (+ loops 10))]
    (subvec (.scores data) loops (+ loops 10))))

(println (clojure.string/join (main 704321)))
