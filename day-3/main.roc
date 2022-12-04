app "day 3"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    # imports [pf.Stdout, pf.Stdin , pf.Task.{await}]
    imports [pf.Stdout, pf.File, pf.Task.{await}, pf.Path ]
    provides [main] to pf


main =
    contents <-
      await (File.readUtf8 (Path.fromStr "input.txt")
        |> Task.onFail (\_err -> Task.succeed "couldn't parse file"))

    priority = Str.split contents "\n"
      |> List.keepOks sharedGrapheme
      |> List.map pointsPerGrapheme
      |> List.sum
      |> Num.toStr

    _ <- await (Stdout.line "priority: \(priority)")

    badgePrioritySum = Str.split contents "\n"
      |>triads
      |> List.map sharedBadgePoints
      |> List.sum
      |> Num.toStr

    Stdout.line "badge priority: \(badgePrioritySum)"



Triad : {a: Str, b: Str, c: Str}

triads : List Str -> List Triad
triads = \lines  ->
  split = List.split lines 3
  when split.before is
    [a, b, c] -> List.append (triads split.others) {a, b, c}
    _ -> []

sharedBadgePoints : Triad -> Nat
sharedBadgePoints = \{a, b, c} ->
  Str.graphemes a
    |> Set.fromList
    |> Set.intersection (Set.fromList (Str.graphemes b))
    |> Set.intersection (Set.fromList (Str.graphemes c))
    |> Set.toList
    |> List.map pointsPerGrapheme
    |> List.sum

sharedGrapheme : Str -> Result Str [ListWasEmpty]
sharedGrapheme = \rucksack ->
  graphemes = Str.graphemes rucksack
  split = List.split graphemes (Num.divTrunc (List.len graphemes) 2)
  Set.intersection (Set.fromList split.before) (Set.fromList split.others)
    |> Set.toList
    |> List.first

# a-z have values 97-122
# A-Z have values 65-90
pointsPerGrapheme : Str -> Nat
pointsPerGrapheme = \grapheme ->
  when (Str.toScalars grapheme) is
      [a] ->  (if a >= 97 then
                  a - 96
              else
                  a - 38
              ) |> Num.toNat
      _ -> 0
