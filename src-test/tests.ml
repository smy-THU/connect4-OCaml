open OUnit2

let test_summate _ = assert_equal 0 0
let int_tests = "Integer tests" >::: [ "Summate" >:: test_summate ]
let () = run_test_tt_main int_tests
