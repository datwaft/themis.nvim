(local {: str? : nil? : tbl? } (require :themis.lib.types))

(tset _G :themis/pack [])
(tset _G :themis/rock [])

(lambda pack [identifier ?options]
  "Return a mixed table with the identifier as the first sequential element and
  options as hash-table items.
  See https://github.com/wbthomason/packer.nvim for information about the
  options.
  Additional to those options you can use 'require*' and 'setup*' to use the
  'config' options with `require(%s)` and `require(%s).setup() respectively.`"
  (assert-compile (str? identifier) "expected string for identifier" identifier)
  (if (not (nil? ?options)) (assert-compile (tbl? ?options) "expected table for options" ?options))
  (let [options (or ?options {})
        options (collect [k v (pairs options)]
                  (match k
                    :require* (values :config (string.format "require(\"%s\")" v))
                    :setup* (values :config (string.format "require(\"%s\").setup()" v))
                    _ (values k v)))]
    (doto options (tset 1 identifier))))

(lambda rock [identifier ?options]
  "Return a mixed table with the identifier as the first sequential element and
  options as hash-table items.
  See https://github.com/wbthomason/packer.nvim for information about the
  options."
  (assert-compile (str? identifier) "expected string for identifier" identifier)
  (if (not (nil? ?options)) (assert-compile (tbl? ?options) "expected table for options" ?options))
  (let [options (or ?options {})]
    (doto options (tset 1 identifier))))

(lambda pack! [identifier ?options]
  "Declares a plugin with its options. This macro adds it to the themis/pack
  global table to later be used in the `unpack!` macro.
  See https://github.com/wbthomason/packer.nvim for information about the
  options."
  (assert-compile (str? identifier) "expected string for identifier" identifier)
  (if (not (nil? ?options)) (assert-compile (tbl? ?options) "expected table for options" ?options))
  (table.insert _G.themis/pack (pack identifier ?options)))

(lambda rock! [identifier ?options]
  "Declares a rock with its options. This macro adds it to the themis/rock
  global table to later be used in the `unpack!` macro.
  See https://github.com/wbthomason/packer.nvim for information about the
  options."
  (assert-compile (str? identifier) "expected string for identifier" identifier)
  (if (not (nil? ?options)) (assert-compile (tbl? ?options) "expected table for options" ?options))
  (table.insert _G.themis/rock (rock identifier ?options)))

(lambda unpack! []
  "Initializes the plugin manager with the plugins previously declared and
  their respective options."
  (let [packs (icollect [_ v (ipairs _G.themis/pack)] `(use ,v))
        rocks (icollect [_ v (ipairs _G.themis/rock)] `(use_rocks ,v))
        use-sym (sym :use)]
    (tset _G :themis/pack [])
    (tset _G :themis/rock [])
    `((. (require :packer) :startup)
      (fn [,use-sym]
        ,(unpack (icollect [_ v (ipairs packs) :into rocks] v))))))

{: pack
 : rock
 : pack!
 : rock!
 : unpack!}
