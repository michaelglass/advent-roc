app "day 1"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    # imports [pf.Stdout, pf.Stdin , pf.Task.{await}]
    imports [pf.Stdout, pf.File, pf.Task.{await}, pf.Path ]
    provides [main] to pf

Elf : List Fruit
Fruit : Nat

main =
    contents <-
      await (File.readUtf8 (Path.fromStr "input.txt")
        |> Task.onFail (\_err -> Task.succeed "couldn't parse file"))

    elves = inputToElves contents

    numElves = List.len elves  |> Num.toStr

    _ <- Stdout.line ("we counted \(numElves) elves")
      |> await

    maxCalories = List.map elves List.sum
      |> List.max
      |> Result.withDefault 0
      |> Num.toStr

    _ <- Stdout.line "max calories: \(maxCalories)"
      |> await


    max3Calories = List.map elves List.sum
      |> List.sortDesc
      |> List.takeFirst 3
      |> List.sum
      |> Num.toStr

    Stdout.line "max 3: \(max3Calories)"



# main =
#     _ <- await (Stdout.line "enter a string")
#     text <- await Stdin.line
#     Stdout.line "You just entered: \(text)"

inputToElves : Str -> List Elf
inputToElves = \input ->
  Str.split input "\n"
    |> List.walk ({elves: [], lastElf: []}) \{elves, lastElf}, fruitOrDelimeter ->
        when Str.toNat(fruitOrDelimeter) is
          Err _ -> {elves: List.append elves lastElf, lastElf:  []}
          Ok num -> {elves: elves, lastElf: List.append lastElf num}
    |> .elves
