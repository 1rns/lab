import re, tokenize, deques


# '*' means it is exported for other modules.
type
  Token* = ref object
    kind*: string
    value*: string

  TrackLiteral = object
    # Used to pause regex matching.
    str: string
    isOn: bool


const TokenPatterns = [
  # 'const' is evaluated at compile time.
  ("literal", "\\\"[[:ascii:]]*\\\""),
  ("assign", "append"),
  ("assign", "set"),
  ("key", "exit"),
  ("key", "list"),
  ("out", "print"),
  ("out", "printlength"),
  ("out", "printwords"),
  ("out", "rintwordcount"),
  ("reverse", "reverse"),
  ("end", ";"),
  ("plus", "\\+"),
  ("constant", "SPACE|TAB|NEWLINE"),
  ("id", "[a-zA-Z][a-zA-Z0-9_]*"),
]




proc matchToken(tokenStr: string): Token =
  result = Token(kind: "", value: "")
  if tokenStr == "": return result
  var matchedBounds: (int, int)
  for (token, pattern) in TokenPatterns:
    # Must match entire length of the token,
    # not just part of it.
    matchedBounds = findBounds(tokenStr, re(pattern))
    if (matchedBounds[0] != -1) and
       (matchedBounds[1] + 1) == tokenStr.len:
      return Token(kind: token, value: tokenStr)




var strBuilder = TrackLiteral(str: "", isOn: false)

proc buildStr(tokenStr: string): Token =
  #[
    An input of `"` will toggle the string (literal) builder,
    which will prevent calling matchToken.

    Any incoming input from the tokenizer will be used to
    build a string until another `"` is passed.

    The ../src/tokenizer.nim module deals with ensuring
    that each unescaped `"` is its own separate token.
  ]#
  if strBuilder.isOn and tokenStr[0] == '"':
    strBuilder.str.add('"')
    result = Token(kind: "literal", value: strBuilder.str)
    strBuilder.isOn = false
    strBuilder.str = ""
  else:
    strBuilder.isOn = true 
    strBuilder.str.add(tokenStr)
    return Token(kind: "", value: "")




proc analyse*(str: string): Deque[Token] =
  # The variable 'result' is implicitly declared & returned.
  var token: Token
  for tokenStr, isSep in str.tokenize():    
    # Tokenizes string, appends tokens to a queue.
    if strBuilder.isOn:
      # Continue building string
      token = buildStr(tokenstr)
      if not strBuilder.isOn:
        # String builder is finished.
        result.addLast(token)
      continue
    if tokenStr[0] == '"':
      # Start building string, ignore first output
      discard buildStr(tokenstr) 

    elif isSep: continue # Ignore whitespace

    else:
      token = matchToken(tokenStr)
      if token.kind == "":
        raise newException(ValueError,
                          "Invalid token: \"" &
                          tokenStr & "\"")
      result.addLast(token)
