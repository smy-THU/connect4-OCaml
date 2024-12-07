echo "Clean and build the project ..."
dune clean && dune build

echo "Test codes and coverage ..."
cd ..
dune test && bisect-ppx-report html && bisect-ppx-report summary
cd -

echo "Launch live demo ..."
dune exec ./bin/connect4.exe
