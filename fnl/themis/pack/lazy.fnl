(local {: str? : nil?} (require :themis.lib.types))

(lambda pack [identifier ?options]
  "A workaround around the lack of mixed tables in Fennel.
  Has special `options` keys for enhanced utility.
  See `:help themis.pack.lazy.pack` for information about how to use it."
  (assert-compile (str? identifier) "expected string for identifier" identifier)
  (assert-compile (or (nil? ?options) (table? ?options)) "expected table for options" ?options)
  (let [options (or ?options {})
        options (collect [k v (pairs options)]
                  (match k
                    :require* (values :config `#(require ,v))
                    _ (values k v)))]
    (doto options (tset 1 identifier))))

{: pack}
