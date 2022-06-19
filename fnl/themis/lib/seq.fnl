(local {: tbl? : nil? : num?} (require :themis.lib.types))
(local itable (require :themis.deps.itable))

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

(lambda flatten [x ?levels]
  (assert (tbl? x) "expected tbl for x")
  (assert (or (nil? ?levels) (num? ?levels)) "expected number or nil for levels")
  (if (or (nil? ?levels) (> ?levels 0))
    (accumulate [output []
                 _ v (ipairs x)]
      (if (tbl? v)
        (itable.join output (flatten v (if (nil? ?levels) nil (- ?levels 1))))
        (itable.insert output v)))
    x))

{: empty?
 : first
 : second
 : last
 : any?
 : all?
 : contains?
 : flatten}
