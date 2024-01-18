#[
  Original code obtained from the standard library; strutils/tokenize:
  https://github.com/nim-lang/Nim/blob/version-1-6/lib/pure/strutils.nim#L2843

  Modified so that it treats ';' and '"', as a single token.
]#


const Whitespace = {' ', '\t', '\v', '\r', '\l', '\f', '\n'}




iterator tokenize*(s: string, seps: set[char] = Whitespace): tuple[
  token: string, isSep: bool] =
  var i = 0
  while true:
    var j = i
    var isSep = j < s.len and s[j] in seps
    if j < s.len:

      if s[j] == ';' or s[j] == '"': inc(j)
      else:
        while j < s.len and ((s[j] in seps) == isSep):
          if (s[j] != ';') and 
                    ((s[j] != '"') or s[j - 1] == '\\'):
            inc(j)
          else:
            break

    if j > i:
      yield (substr(s, i, j-1), isSep)
    else:
      break
    i = j