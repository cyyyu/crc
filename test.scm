#! /usr/local/bin/csi -s

(load "./crc.scm")

(import crc)

(define client (crc-connect "localhost" 6379))

;; set key "a", "b"
(pp (client crc-set "a" "123"))
(pp (client crc-set "b" "456"))
(pp (client crc-get "a"))
(pp (client crc-get "b"))

;; get all keys
(pp (client crc-keys "*"))

;; del key "a"
(pp (client crc-del "a"))

;; get all keys
(pp (client crc-keys "*"))

;; flushall keys
(pp (client crc-flushall))

;; get all keys
(pp (client crc-keys "*"))
