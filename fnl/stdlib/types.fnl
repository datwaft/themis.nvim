(fn nil? [x]
  (= nil x))

(fn str? [x]
  (= :string (type x)))

(fn num? [x]
  (= :number (type x)))

(fn fn? [x]
  (= :function (type x)))

(fn tbl? [x]
  (= :table (type x)))

(fn ->str [x]
  (tostring x))

{: nil?
 : str?
 : num?
 : fn?
 : tbl?
 : ->str}
