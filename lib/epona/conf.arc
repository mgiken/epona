(= sysdir* nil appdir* nil)

(deftem conf
  pubdir      (string appdir* "/pub")
  tmpdir      (string appdir* "/tmp")
  logdir      (string appdir* "/log")
  srv-host    "127.0.0.1"
  srv-port    8080
  srv-timeout 30
  db-host     "127.0.0.1"
  db-port     5984
  db-name     nil
  repl-port   8081
  debug       nil
  reload      nil)

(= conf* (inst 'conf))

(def load-conf (file)
  (= conf* (temload 'conf file)))
