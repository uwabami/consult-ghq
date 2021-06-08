consult-ghq
-------

Introduction
============

`consult-ghq` provides interfaces of ghq with [consult](https://github.com/minad/consult).

Requirements
============

* Emacs 27.1 or higher: I use this program on Emacs 27.1
* [ghq](https://github.com/motemen/ghq)

Setup and Customize
===================

``` common-lisp
(add-to-list 'load-path "somewhere")
(require 'consult-ghq)
(setq consult-ghq-short-list t)   ;;  Whether display full path or short path
```

Usage
=====

`consult-ghq`: Execute `ghq list --full-path` and Open selected directory by dired.


License
=======

This program is folk of [emacs-helm-ghq](https://github.com/masutaka/emacs-helm-ghq).
License is same as original, GPL-3+.
