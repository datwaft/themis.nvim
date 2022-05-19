(lambda empty? [xs]
  (= 0 (length xs)))

(lambda first [xs]
  (?. xs 1))

(lambda second [xs]
  (?. xs 2))

(lambda last [xs]
  (?. xs (length xs)))

(lambda contains? [xs x]
  (accumulate [contains? false
               _ v (ipairs xs)
               :until contains?]
    (= v x)))

{: empty?
 : first
 : second
 : last
 : contains?}
