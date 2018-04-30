#! /usr/local/bin/csi -s

(load "./crc.scm")

(import crc)

(define client (crc-connect "localhost" 6379))

(pp (client crc-keys "*"))

(pp (client crc-set "a" "456"))

(pp (client crc-get "a"))

