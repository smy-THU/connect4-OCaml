(lang dune 3.16)
 (generate_opam_files true)
 (authors "Mingyuan Shen" "Shunchi Zhang")
 (maintainers "mshen37@jh.edu" "szhan256@jh.edu")
 (package
  (name connect4) ; put in your own project name here
  (allow_empty)
  (synopsis "Web Connect game")
  (description "A interactive web Connect4 game implemented in OCaml, with a Game Theory Library that implements minimax, alpha-beta pruning and Monte Carlo Tree Search algorithms")
  (depends
   (ounit2 (>= 2.2.7)) ; for each opam dependency list the version
   (core (>= 0.17.1)) ; `opam list core` will display which version of core you have
   (dream (>= "1.0.0~alpha7"))
))