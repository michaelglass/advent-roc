app "day 2"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    # imports [pf.Stdout, pf.Stdin , pf.Task.{await}]
    imports [pf.Stdout, pf.File, pf.Task.{await}, pf.Path ]
    provides [main] to pf


main =
    contents <-
      await (File.readUtf8 (Path.fromStr "input.txt")
        |> Task.onFail (\_err -> Task.succeed "couldn't parse file"))

    points = Str.split  contents "\n"
              |> List.map \input -> (pointsForGame input) + (pointsForThrow input)
              |> List.sum
              |> Num.toStr

    _ <- await (Stdout.line "total points: \(points)")

    points2 = Str.split  contents "\n"
              |> List.map \input -> (pointsForGame2 input)
              |> List.sum
              |> Num.toStr

    Stdout.line "total points: \(points2)"


pointsForGame : Str -> Nat
pointsForGame = \input ->
   when input is
    "A X" -> 3 # TIE  rock rock
    "A Y" -> 6 # WIN  rock < paper
    "A Z" -> 0 # LOSE rock > scissors

    "B X" -> 0 # LOSE paper > rock
    "B Y" -> 3 # TIE  paper = paper
    "B Z" -> 6 # WIN  paper > scissors

    "C X" -> 6 # WIN  scissors < rock
    "C Y" -> 0 # LOSE scissors > paper
    "C Z" -> 3 # TIE  scissors = scissors
    _ -> 0

pointsForGame2 : Str -> Nat
pointsForGame2 = \input ->
   when input is
    "A X" -> 0 + 3 # rock lose -> scissors
    "A Y" -> 3 + 1 # rock draw -> rock
    "A Z" -> 6 + 2 # rock win -> paper

    "B X" -> 0 + 1 # paper lose -> rock
    "B Y" -> 3 + 2 # paper draw -> paper
    "B Z" -> 6 + 3 # paper win -> scissors

    "C X" -> 0 + 2 # scissors lose -> paper
    "C Y" -> 3 + 3 # scissors draw -> scissors
    "C Z" -> 6 + 1 # scissors win -> rock
    _ -> 0



pointsForThrow : Str -> Nat
pointsForThrow = \input ->
  when List.last (Str.graphemes input) is
    Ok "X" -> 1
    Ok "Y" -> 2
    Ok "Z" -> 3
    _ -> 0
