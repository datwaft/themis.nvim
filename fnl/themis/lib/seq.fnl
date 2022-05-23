(lambda empty? [xs]
  (= 0 (length xs)))

(lambda first [xs]
  (?. xs 1))

(lambda second [xs]
  (?. xs 2))

(lambda last [xs]
  (?. xs (length xs)))

(lambda any? [pred xs]
  (accumulate [any? false
               _ v (ipairs xs)
               :until any?]
    (pred v)))

(lambda all? [pred xs]
  (not (any? #(not (pred $)) xs)))

(lambda contains? [xs x]
  (any? #(= $ x) xs))

{: empty?
 : first
 : second
 : last
 : any?
 : all?
 : contains?}
