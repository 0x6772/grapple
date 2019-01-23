* db
  * flat file colon^Wpipe separated fields, comma-sub-separated
    - pro:
      - CLI friendly
      - encrypt/compress friendly
    - con:
      - eliminates N chars or req's escapes
      - easy to get multiple repos out of sync
    - been using foo@bar.com @ remote.site:password which is human
    readable but programmatically shitty; @ can't be a reserved char
    when email addresses are usernames
    - separator:
      - colon's bad too if we want URIs
      - pipe instead? (need to exclude from pws)
      - wait, do we need *space* anywhere else?
        - yes, in password recovery prompts
    - support UTF-8 for pws / all fields?
      - is there a UTF-8 char we can rely on as a separator?
  * xSQL
    - pro:
      - offload uniq/sort/search to DB engine?
      - easy to keep multiple repos in sync
    - con:
      - pita to read files manually
      - potentially buries encryption in [R]DBMS
  * fields:
    - username (multiple, comma-sep)
    - "site"
      - define better?
      - req URI format? (seems easier, but URIs want colons)
      - logon URI and pw change URI aren't the same
      - multiple comma-separated entries?
        - or just separate record for different URL?
          (eg salliemae.com/navient.com); don't think there's a good
          reason
      - same deal for wifi base stations
        "IP address[,hostname],SSID[,SSID]")
    - password
      - special handling (wrt clipboard) for CCs, because we need
        expr date & chksum:
          - username = "<date> <chksum>"
          - password = card number
          - pin = oh, right this uses pins too
        - this muddles the use case a bit, but makes the most sense
          for copy/paste and display, I think
      - for checking/savings accounts:
          - username = name on check
          - site = name of bank
          - password = "<routing number> <acct number>"
            - XXX should those be split for pasting? Hrm.
    - PIN (some accts need both)
    - auto-change (boolean)
    - change url
      - define uris & use more clearly
    - password requirements
* ui
  * create
    - generate
  * retrieve / query
    - lazy is just walk the file, but store in an internal DB may
      be better
    - hash on $username\@$site?
    - if that's the internal format, how do we deal with writing
      out?
    - by default, move to Clipboard, but need a flag for "no really,
      show me on the screen, I'm typing it into something else"
  * synchronize
    * extant sync_enc.pl
    * handle primary/shared/current versioning?
      - tagged version history?
      - pay attention to file timestamps
        - super bad across FS types
      - assert primacy if making changes?
      - assert primacy by proof of private key ownership seems
      better
      - detached(/able) token should be able to accept updates if
      requested, otherwise overwrites
        - XXX think about that some more
  * update (our repo)
  * change (on the target "site")
    * special case: change all
    * need to:
      - interact with remote devs via APIs? Yeah, SSH ie easy: let's
			talk about AD or anything that wants 2fa.
      - interact with websites via... eh? What a shambles.
      - probably interact with local system paste buffer as a cheat,
			needs context-smart prompts. Woof.
