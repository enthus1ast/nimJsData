import strutils, sequtils

func jarr*(ss: openarray[SomeNumber]): string {.inline.}=
  ## transforms an openarray[SomeNumber] to valid js string
  result &= "["
  result.add ss.join(",")
  result &= "]"

func jarr*(ss: HSlice[int, int]): string {.inline.}=
  ## transforms an openarray[SomeNumber] to valid js string
  result &= "["
  result.add toSeq(ss).join(",")
  result &= "]"

func jarr*(ss: openarray[string], unsafe = false): string {.inline.}=
  ## transforms an openarray[string] to valid js string
  ## if unsafe == true, this does not escape strings, but its much faster.
  result &= "["
  if unsafe:
    result.add ss.mapIt("\"" & it & "\"").join(",")
  else:
    for idx, elem in ss:
      var cur = "\""
      for ch in elem:
        case ch
        of '"': cur.add "\\\""
        of '\\': cur.add "\\\\"
        else: cur.add ch
      cur.add "\""
      if idx == ss.len-1:
        result.add cur
      else:
        result.add cur & ","
  result &= "]"



when isMainModule:
  import benchy
  block:
    var ss = @[1.0,2,3]
    echo ss.jarr
  block:
    var ss = @["foo", "b\"aa", "b\\az"]
    echo ss.jarr(unsafe = true)
    echo ss.jarr(unsafe = false)

  block:
    var ss = @["foo"]
    for idx in 0..100_000:
      ss.add $idx
    timeIt "safe str":
      keep ss.jarr(unsafe = false)
    timeIt "unsafe str":
      keep ss.jarr(unsafe = true)

  block:
    var ss = @[0]
    for idx in 0..100_000:
      ss.add idx
    timeIt "int":
      keep ss.jarr()

