(= sysdir* nil appdir* nil)

(deftem conf
  pubdir      (string appdir* "/pub")
  tmpdir      (string appdir* "/tmp")
  logdir      (string appdir* "/log")
  pwdgst-salt      "UTWHDRyaCjC06TxS6r1ktKykZ3DVgzeJOnePGqOaUtJNyKmMzvpzO3F3reJI1CXpEovg2QPu4HO8zaoEb6Wdgt3OjvJI6LiX3SfTfv4S6EyGjBNlK3HERwug7g1vCT8n"
  pwdgst-stretches 5000
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
