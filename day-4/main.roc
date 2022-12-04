app "hello"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    # imports [pf.Stdout, pf.Stdin , pf.Task.{await}]
    imports [pf.Stdout, pf.File, pf.Task.{await}, pf.Path ]
    provides [main] to pf


main =
    contents <-
      await (File.readUtf8 (Path.fromStr "input.txt")
        |> Task.onFail (\_err -> Task.succeed "couldn't parse file"))

    pairs = Str.split contents "\n"
      |> List.keepOks rangePairs

    numUnnecessary = List.countIf pairs rangeUnnecessary
      |> Num.toStr

    Stdout.line "num fully included: \(numUnnecessary)"

RangePair : { first: ElfRange, second: ElfRange }
ElfRange : {start: Nat, end: Nat}

rangePairs : Str -> Result RangePair Str
rangePairs  = \line ->
  when (List.keepOks (Str.split line ",") elfRange) is
    [fst, snd] ->  Ok { first: fst, second: snd }
    _ -> Err "invalid line - should be two ranges"

elfRange : Str -> Result ElfRange Str
elfRange = \pair ->
    when (Str.split pair "-") |> List.keepOks Str.toNat  is
      [start, end] -> Ok { start: start, end: end}
      _ -> Err "invalid range"

rangeUnnecessary : RangePair -> Bool
rangeUnnecessary = \pair ->
  (rangeUnnecessaryP pair.first pair.second) || (rangeUnnecessaryP pair.second pair.first)

rangeUnnecessaryP : ElfRange, ElfRange -> Bool
rangeUnnecessaryP = \first, second ->
  first.start <= second.start && first.end >= second.end
