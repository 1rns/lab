#[
  The program is an interpreter that will take user
  input and interpret it according to the grammar.

  This main module will run in an infinite loop to receive
  user input, and moves data between the three modules.

  The lexer module takes a string, and tokenizes it
  into a queue of tokens. The tokenizer function is
  located in its own module.

  The parser receives the queue, and constructs an AST. It
  returns a queue of root nodes (in case the user passes
  multiple statements at once).

  Finally, the interpreter traverses the tree(s) and
  performs the necessary operations.
]#

{.experimental: "strictFuncs".} # Force funcs to be pure.

from lexer import nil           # 'import nil' forces dot
from parser import nil          #  operator instead of
from interpreter import nil     #  importing to global scope.
import deques

echo """
----------------------------------------
github.com/lauvrens
----------------------------------------
"""

var currentTokens = initDeque[lexer.Token]()
while true:
  var line = readLine(stdin)
  if line == "": continue
  line.add("\n") # stdin ignores newlines, this adds them back

  try:
    # - Lexer - #
    var newTokens = lexer.analyse(line)

    for token in newTokens:
      currentTokens.addLast(token)


    # - Parser - #
    var (node, leftover) = parser.parse(currentTokens)
    # Leftover tokens are queued into next iteration.
    currentTokens = leftover


    # - Interpreter - #
    interpreter.interpret(node)


  except ValueError:
    echo getCurrentExceptionMsg() & "\nTry again.\n"
    # Errors will most likely occur in the lexer or parser,
    # so all tokens must be removed from the queue.
    currentTokens.clear()
