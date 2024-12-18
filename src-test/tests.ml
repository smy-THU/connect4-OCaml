
open OUnit2

let series =
  "All Tests" >::: 
  [ Judge_tests.series
  ; Alpha_beta_tests.series
  ; Minimax_tests.series
  ; Mcts_tests.series
  ; Connect4_tests.series
  ; Connect4_ban_tests.series]

let () = run_test_tt_main series 

