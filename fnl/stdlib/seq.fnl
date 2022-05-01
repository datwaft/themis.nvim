(lambda empty? [xs]
  (= 0 (length xs)))

(lambda first [xs]
  (?. xs 1))

(lambda second [xs]
  (?. xs 2))

(lambda last [xs]
  (?. xs (length xs)))

{: empty?
 : first
 : second
 : last}
