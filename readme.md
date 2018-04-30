# CRC

> Chicken scheme Redis Client.

A toy implementation of [RESP(REdis Serialization Protocol)](https://redis.io/topics/protocol) for chicken scheme.

### Examples

```scheme
(import crc)

(define client (crc-connect "localhost" 6379))

(pp (client crc-set "a" "456"))
;; "ok"

(pp (client crc-get "a"))
;; "456"

(pp (client crc-keys "*"))
;; ("a")

```

### Author

Chuang Yu <cyu9960@gmail.com>

### License

MIT
