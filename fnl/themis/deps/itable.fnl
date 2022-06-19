(local {:pack table-pack
        :sort table-sort
        :concat table-concat
        :remove table-remove
        :move table-move
        :insert table-insert}
  table)

(local table-unpack (or table.unpack _G.unpack))
(local lua-pairs pairs)
(local lua-ipairs ipairs)

(fn pairs [t]
  "A variant of `pairs` function that gets correct `__pairs` metamethod from `t`.

Note, both `pairs', `ipairs', and `length' should only be needed on
Lua 5.1 and LuaJIT where there's no direct support for such
metamethods."
  ((match (getmetatable t)
     {:__pairs p} p
     _ lua-pairs) t))

(fn ipairs [t]
  "A variant of `ipairs` function that gets correct `__ipairs` metamethod from `t`."
  ((match (getmetatable t)
     {:__ipairs i} i
     _ lua-ipairs) t))

(fn length* [t]
  "A variant of `length` function that gets correct `__len` metamethod from `t`."
  ((match (getmetatable t)
     {:__len l} l
     _ (partial length)) t))

(fn copy [t]
  ;; Shallow copy the given table.  Intentionally returns mutable copy
  ;; with no metatable copied.
  (when t
    (collect [k v (pairs t)]
      (values k v))))

(fn immutable [t]
  ;; Return a proxy table with precalculated `__len`, and `__newindex`
  ;; metamethod that ensures immutability.  `__pairs` metamethod
  ;; operates on a shallow copy, to prevent mutable table leaking.
  ;; Tables can be called with one argument to lookup keys.
  (let [len (length* t)
        proxy {}
        __len #len
        __index #(. t $2) ; avoid exposing closure via `debug.getmetatable`
        __newindex #(error (.. (tostring proxy) " is immutable") 2)
        __pairs #(values (fn [_ k] (next t k)) nil nil) ; avoid exposing closure via `pairs`
        __ipairs #(fn [_ k] (next t k)) ; Lua 5.2-5.3 compat
        __call #(. t $2)
        __fennelview #($2 t $3 $4)
        __fennelrest #(immutable [(table-unpack t $2)])]
    (setmetatable proxy
                  {: __index
                   : __newindex
                   : __len
                   : __pairs
                   : __ipairs
                   : __call
                   ;; metatable impostor that acts as a public
                   ;; metatable for LuaJIT to work.  Deliberately
                   ;; doesn't expose __index and __newindex
                   ;; metamethods.
                   :__metatable {: __len
                                 : __pairs
                                 : __ipairs
                                 : __call
                                 : __fennelrest
                                 : __fennelview}})))

;;; Default functions

(fn insert [t ...]
  "Inserts element at position `pos` into sequential table,
shifting up the elements.  The default value for `pos` is table length
plus 1, so that a call with just two arguments will insert the value
at the end of the table.  Returns a new immutable table.

# Examples

Original table is not modified, when element is inserted:

``` fennel
(local t1 [1 2 3])
(assert-eq [1 2 3 4] (itable.insert t1 4))
(assert-eq [1 2 3] t1)
```

New table is immutable:

``` fennel
(local t1 [1 2 3])
(local t2 (itable.insert t1 4))
(assert-not (pcall table.insert t2 5))
```"
  (let [t (copy t)]
    (match (values (select :# ...) ...)
      (0) (error "wrong number of arguments to 'insert'")
      (1 ?v) (table-insert t ?v)
      (_ ?k ?v) (table-insert t ?k ?v))
    (immutable t)))


(local move
  (when table-move
    (fn [src start end tgt dest]
      "Move elements from `src` table to `dest` starting at `start` to `end`,
placing elements from `tgt` and up.  The default for `dest` is `src`.
The destination range can overlap with the `src` range.  The number of
elements to be moved must fit in a Lua integer.  Returns new immutable
table.

# Examples

Move elements from 3 to 5 to another table's end:

``` fennel
(local t1 [1 2 3 4 5 6 7])
(local t2 [10 20])
(assert-eq [10 20 3 4 5] (itable.move t1 3 5 3 t2))
(assert-eq t1 [1 2 3 4 5 6 7])
(assert-eq t2 [10 20])
```"
      (let [src (copy src)
            dest (copy dest)]
        (-> src
            (table-move start end tgt dest)
            immutable)))))

;; portable table.pack implementation
(fn pack [...]
  "Pack values into immutable table with size indication."
  (-> [...]
      (doto (tset :n (select :# ...)))
      immutable))


(fn remove [t key]
  "Remove `key` from table, and return a new immutable table and value
that was associated with the `key`.

# Examples

Remove element from the end of the table:


``` fennel
(local t1 [1 2 3])
(local (t2 v) (itable.remove t1))

(assert-eq t1 [1 2 3])
(assert-eq t2 [1 2])
(assert-eq v 3)
```

The newly produced table is immutable:

``` fennel
(assert-not (pcall table.insert (itable.remove [1 2 3])))
```"
  (let [t (copy t)
        v (table-remove t key)]
    (values (immutable t) v)))


(fn concat [t sep start end serializer opts]
  "Concatenate each element of sequential table with separator `sep`.

Optionally supports `start` and `end` indexes, and a `serializer`
function, with a table `opts` for that serialization function.

If no serialization function is given, `tostring` is used.

``` fennel
(local {: view} (require :fennel))
(local t [1 2 {:a 1 :b 2}])
(assert-eq (itable.concat t \", \" nil nil view {:one-line? true})
           \"1, 2, {:a 1 :b 2}\")
```"

  (let [serializer (or serializer tostring)]
    (table-concat (icollect [_ v (ipairs t)]
                    (serializer v opts)) sep start end)))


(fn unpack [t]
  "Unpack immutable table.

Note, that this is needed only in LuaJit and Lua 5.2, because of how
metamethods work."
  (table-unpack (copy t)))


;;; Extras

(fn eq [...]
  "Deep comparison.

Works on table keys that itself are tables.  Accepts any amount of
elements.

``` fennel
(assert-is (eq 42 42))
(assert-is (eq [1 2 3] [1 2 3]))
```

Deep comparison is used for tables:

``` fennel
(assert-is (eq {[1 2 3] {:a [1 2 3]} {:a 1} {:b 2}}
               {{:a 1} {:b 2} [1 2 3] {:a [1 2 3]}}))
(assert-is (eq {{{:a 1} {:b 1}} {{:c 3} {:d 4}} [[1] [2 [3]]] {:a 2}}
               {[[1] [2 [3]]] {:a 2} {{:a 1} {:b 1}} {{:c 3} {:d 4}}}))
```"
  (match (values (select :# ...) ...)
    (where (or (0) (1)))
    true
    (2 ?a ?b)
    (if (= ?a ?b)
        true
        (= (type ?a) (type ?b) :table)
        (do (var (res count-a count-b) (values true 0 0))
            (each [k v (pairs ?a) :until (not res)]
              (set res (eq v (do (var res nil)
                                 (each [k* v (pairs ?b) :until res]
                                   (when (eq k* k)
                                     (set res v)))
                                 res)))
              (set count-a (+ count-a 1)))
            (when res
              (each [_ _ (pairs ?b)]
                (set count-b (+ count-b 1)))
              (set res (= count-a count-b)))
            res)
        false)
    (_ ?a ?b)
    (and (eq ?a ?b) (eq (select 2 ...)))))


(fn assoc [t key val]
  "Associate `val` under a `key`.

# Examples

``` fennel
(assert-eq {:a 1 :b 2} (itable.assoc {:a 1} :b 2))
(assert-eq {:a 1 :b 2} (itable.assoc {:a 1 :b 1} :b 2))
```"
  (immutable (doto (copy t) (tset key val))))


(fn assoc-in [t [k & ks] val]
  "Associate `val` into set of immutable nested tables `t`, via given keys.
Returns a new immutable table.  Returns a new immutable table.

# Examples

Replace value under nested keys:

``` fennel
(assert-eq
 {:a {:b {:c 1}}}
 (itable.assoc-in {:a {:b {:c 0}}} [:a :b :c] 1))
```

Create new entries as you go:

``` fennel
(assert-eq
 {:a {:b {:c 1}} :e 2}
 (itable.assoc-in {:e 2} [:a :b :c] 1))
```"
  (let [t (or t {})]
    (if (next ks)
        (assoc t  k (assoc-in (or (. t k) {}) ks val))
        (assoc t  k val))))


(fn update [t key f]
  "Update table value stored under `key` by calling a function `f` on
that value. `f` must take one argument, which will be a value stored
under the key in the table.

# Examples

Same as `assoc' but accepts function to produce new value based on key value.

``` fennel
(assert-eq
 {:data \"THIS SHOULD BE UPPERCASE\"}
 (itable.update {:data \"this should be uppercase\"} :data string.upper))
```"
  (immutable (doto (copy t) (tset key (f (. t key))))))


(fn update-in [t [k & ks] f]
  "Update table value stored under set of immutable nested tables, via
given keys by calling a function `f` on the value stored under the
last key.  `f` must take one argument, which will be a value stored
under the key in the table.  Returns a new immutable table.

# Examples

Same as `assoc-in' but accepts function to produce new value based on key value.

``` fennel
(fn capitalize-words [s]
  (pick-values 1
    (s:gsub \"(%a)([%w_']*)\" #(.. ($1:upper) ($2:lower)))))

(assert-eq
 {:user {:name \"John Doe\"}}
 (itable.update-in {:user {:name \"john doe\"}} [:user :name] capitalize-words))
```"
  (let [t (or t [])]
    (if (next ks)
        (assoc t k (update-in (. t k) ks f))
        (update t k f))))


(fn deepcopy [x]
  "Create a deep copy of a given table, producing immutable tables for nested tables.
Copied table can't contain self references."
  (fn deepcopy* [x seen]
    (match (type x)
      :table (match (. seen x)
               true (error "immutable tables can't contain self reference" 2)
               _ (do (tset seen x true)
                     (-> (collect [k v (pairs x)]
                           (values (deepcopy* k seen)
                                   (deepcopy* v seen)))
                         immutable)))
      _ x))
  (deepcopy* x {}))


(fn first [[x]]
  "Return the first element from the table."
  x)


(fn rest [t]
  "Return all but the first elements from the table `t` as a new immutable
table."
  (pick-values 1 (remove t 1)))


(fn nthrest [t n]
  "Return all elements from `t` starting from `n`.  Returns immutable
table."
  (let [t* []]
    (for [i (+ n 1) (length* t)]
      (table-insert t* (. t i)))
    (immutable t*)))


(fn last [t]
  "Return the last element from the table."
  (. t (length* t)))


(fn butlast [t]
  "Return all elements but the last one from the table as a new
immutable table."
  (pick-values 1 (remove t (length* t))))


(fn join [...]
  "Join arbitrary amount of tables, and return a new immutable table.

# Examples

``` fennel
(local t1 [1 2 3])
(local t2 [4])
(local t3 [5 6])

(assert-eq [1 2 3 4 5 6] (itable.join t1 t2 t3))
(assert-eq t1 [1 2 3])
(assert-eq t2 [4])
(assert-eq t3 [5 6])
```"
  (match (values (select :# ...) ...)
    (0) nil
    (1 ?t) (immutable (copy ?t))
    (2 ?t1 ?t2) (let [to (copy ?t1)
                      from (or ?t2 [])]
                  (each [_ v (ipairs from)]
                    (table-insert to v))
                  (immutable to))
    (_ ?t1 ?t2) (join (join ?t1 ?t2) (select 3 ...))))


(fn take [n t]
  "Take first `n` elements from table `t` and return a new immutable
table.

# Examples

Take doesn't modify original table:

```fennel
(local t1 [1 2 3 4 5])

(assert-eq [1 2 3] (itable.take 3 t1))
(assert-eq t1 [1 2 3 4 5])
```"
  (let [t* []]
    (for [i 1 n]
      (table-insert t* (. t i)))
    (immutable t*)))


(fn drop [n t]
  "Drop first `n` elements from table `t` and return a new immutable
table.

# Examples

Take doesn't modify original table:

```fennel
(local t1 [1 2 3 4 5])

(assert-eq [4 5] (itable.drop 3 t1))
(assert-eq t1 [1 2 3 4 5])
```"
  (nthrest t n))


(fn partition [...]
  "Returns a immutable table of tables of `n` elements, at `step`
offsets.  `step defaults to `n` if not specified.  Additionally
accepts a `pad` collection to complete last partition if it doesn't
have sufficient amount of elements.

# Examples
Partition table into sub-tables of size 3:

``` fennel
(assert-eq (itable.partition 3 [1 2 3 4 5 6])
           [[1 2 3] [4 5 6]])
```

When table doesn't have enough elements to form full partition,
`partition` will not include those:

``` fennel
(assert-eq (itable.partition 2 [1 2 3 4 5]) [[1 2] [3 4]])
```

Partitions can overlap if step is supplied:

``` fennel
(assert-eq (itable.partition 2 1 [1 2 3 4]) [[1 2] [2 3] [3 4]])
```

Additional padding can be used to supply insufficient elements:

``` fennel
(assert-eq (itable.partition 3 3 [-1 -2 -3] [1 2 3 4 5 6 7])
           [[1 2 3] [4 5 6] [7 -1 -2]])
```"
  (let [res []]
    (fn partition* [...]
      (match (values (select :# ...) ...)
        (where (or (0) (1))) (error "wrong amount arguments to 'partition'")
        (2 ?n ?t) (partition* ?n ?n ?t)
        (3 ?n ?step ?t) (let [p (take ?n ?t)]
                          (when (= ?n (length* p))
                            (table-insert res p)
                            (partition* ?n ?step [(table-unpack ?t (+ ?step 1))])))
        (_ ?n ?step ?pad ?t) (let [p (take ?n ?t)]
                               (if (= ?n (length* p))
                                   (do (table-insert res p)
                                       (partition* ?n ?step ?pad [(table-unpack ?t (+ ?step 1))]))
                                   (table-insert res (take ?n (join p ?pad)))))))
    (partition* ...)
    (immutable res)))


(fn keys [t]
  "Return all keys from table `t` as an immutable table."
  (-> (icollect [k _ (pairs t)] k)
      immutable))


(fn vals [t]
  "Return all values from table `t` as an immutable table."
  (-> (icollect [_ v (pairs t)] v)
      immutable))


(fn group-by [f t]
  "Group table items in an associative table under the keys that are
results of calling `f` on each element of sequential table `t`.
Elements that the function call resulted in `nil` returned in a
separate table.

# Examples

Group rows by their date:

``` fennel
(local rows
  [{:date \"2007-03-03\" :product \"pineapple\"}
   {:date \"2007-03-04\" :product \"pizza\"}
   {:date \"2007-03-04\" :product \"pineapple pizza\"}
   {:date \"2007-03-05\" :product \"bananas\"}])

(assert-eq (itable.group-by #(. $ :date) rows)
           {\"2007-03-03\"
            [{:date \"2007-03-03\" :product \"pineapple\"}]
            \"2007-03-04\"
            [{:date \"2007-03-04\" :product \"pizza\"}
             {:date \"2007-03-04\" :product \"pineapple pizza\"}]
            \"2007-03-05\"
            [{:date \"2007-03-05\" :product \"bananas\"}]})
```"
  (let [res {}
        ungroupped []]
    (each [_ v (pairs t)]
      (let [k (f v)]
        (if (not= nil k)
            (match (. res k)
              t* (table-insert t* v)
              _ (tset res k [v]))
            (table-insert ungroupped v))))
    (values (-> (collect [k t (pairs res)]
                  (values k (immutable t)))
                immutable)
            (immutable ungroupped))))


(fn frequencies [t]
  "Return a table of unique entries from table `t` associated to amount
of their appearances.

# Examples

Count each entry of a random letter:

``` fennel
(let [fruits [:banana :banana :apple :strawberry :apple :banana]]
  (assert-eq (itable.frequencies fruits)
             {:banana 3
              :apple 2
              :strawberry 1}))
```"
  (let [res {}]
    (each [_ v (pairs t)]
      (match (. res v)
        a (tset res v (+ a 1))
        _ (tset res v 1)))
    (immutable res)))


(local itable
  {:sort (fn [t f]
           "Return new immutable table of sorted elements from `t`.  Optionally
accepts sorting function `f`. "
           (-> t copy (doto (table-sort f)) immutable))
   : pack
   : unpack
   : concat
   : insert
   : move
   : remove
   ;; LuaJIT compat
   : pairs
   : ipairs
   :length length*
   ;; extras
   : eq
   : deepcopy
   : assoc
   : assoc-in
   : update
   : update-in
   : keys
   : vals
   : group-by
   : frequencies
   ;; sequential extras
   : first
   : rest
   : nthrest
   : last
   : butlast
   : join
   : partition
   : take
   : drop})

(setmetatable
 itable
 {:__call #(-> $2 copy immutable)
  :__index {:_MODULE_NAME "itable"
            :_DESCRIPTION
            "`itable` - immutable tables for Lua runtime."}})
;; LocalWords:  metatable precalculated metamethod
