(module crc *

        (import chicken scheme extras)

        (use socket)

        (define-syntax crc-make-commands
          (er-macro-transformer
            (lambda (exp rename compare)
              `(begin
                ,@(map
                    (lambda (command)
                      `(define ,command
                         (lambda (ip op args)
                           (crc-write op 
                                    ,(cadr
                                       (string-split
                                         (symbol->string command) "-")) args)
                           (crc-read ip))))
                    (cdr exp))))))

        ;; todo: add more commands
        ;; crc-<command>
        (crc-make-commands crc-keys crc-get crc-set)

        (define crc-format-bulks
          (lambda (command args)
            (define bulk-strings
              (apply
                string-append
                (map
                  (lambda (arg)
                    (format "$~A\r\n~A\r\n"
                            (string-length arg) arg)) args)))
            (format "*~A\r\n$~A\r\n~A\r\n~A~!"
                    (+ 1 (length args))
                    (string-length command)
                    command
                    bulk-strings)))

        (define crc-write
          (lambda (op command args)
            (format op (crc-format-bulks command args))))

        ;; todo: a nicer format
        (define crc-read
          (lambda (ip)
            (letrec ((l (lambda () '()))
                     (read-s (lambda (l)
                               (let ([s (read-line ip)])
                                 (if (not (char-ready? ip))
                                   (cons s l)
                                   (read-s (cons s l)))))))
              (reverse (read-s (l))))))

        (define-syntax crc-dispatcher
          (er-macro-transformer
            (lambda (exp rename compare)
              (let ([ip (cadr exp)]
                    [op (caddr exp)])
                `(lambda (command . args)
                   (command ,ip ,op args))))))

        (define crc-connect
          (lambda (host port)
            (define-values (ip op)
              (socket-i/o-ports
                (socket-connect/ai
                  (address-information host port family: af/inet))))
            (crc-dispatcher ip op)))

        )
