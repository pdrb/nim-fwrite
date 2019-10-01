# fwrite 1.0.0
# author: Pedro Buteri Gonring
# email: pedro@bigode.net
# date: 20190930

import
  os, parseopt, random, strutils


const fwriteVer = "1.0.0"


# Show the program usage options
proc printHelp() =
  quit("""Usage: fwrite filename size [options]

create files of the desired size, e.g., 'fwrite test 10M'

Options:
  -v, --version     show program's version number and exit
  -h, --help        show this help message and exit
  -r, --random      use random data (very slow)
  -l, --linefeed    append line feed every 1023 bytes
""", QuitSuccess)


# Parse and validate arguments
proc parseOpts(): tuple =
  var args = newSeq[string]()
  var opts = (
    filename: "",
    size: 0,
    random: false,
    linefeed: false
  )
  if paramCount() == 0:
    printHelp()
  let validOpts = ["v", "version", "h", "help", "r", "random", "l", "linefeed"]
  var p = initOptParser()
  for kind, key, val in p.getopt():
    case kind
    of cmdArgument:
      args.add(key)
    of cmdLongOption, cmdShortOption:
      if key notin validOpts:
        quit("Error: invalid option '$1', use 'fwrite -h' for help" % key)
      case key
      of "v", "version":
        quit(fwriteVer, QuitSuccess)
      of "h", "help":
        printHelp()
      of "r", "random":
        if val == "":
          opts.random = true
        else:
          quit("Error: random option does not need a value, use just '-r'")
      of "l", "linefeed":
        if val == "":
          opts.linefeed = true
        else:
          quit("Error: linefeed option does not need a value, use just '-l'")
    of cmdEnd:
      discard
  if args.len != 2:
    quit("Error: fwrite needs 2 arguments, use 'fwrite -h' for help")
  opts.filename = args[0]
  try:
    opts.size = parseInt(args[1][0..^2])
  except:
    quit("Error: invalid size '$1'" % args[1])
  if opts.size <= 0:
    quit("Error: size must be greater than zero")
  case args[1][^1].toUpperAscii()
  of 'K':
    discard
  of 'M':
    opts.size = opts.size * 1024
  of 'G':
    opts.size = opts.size * 1024 * 1024
  else:
    quit("Error: missing or invalid unit of measurement (K, M or G)")
  return opts


# Generate a random string containing only hexadecimal chars
proc genHexString(size: int): string =
  var newstr = ""
  for i in 1..size:
    newstr.add(HexDigits.sample())
  return newstr


# Create file of the desired size in KBytes
proc createFile(filename: string, size: int, randChars: bool = false,
                linefeed: bool = false) =
  let lineSize = 1024
  var line = ""
  line = repeat('0', lineSize)
  var newFile = open(filename, fmWrite)
  for i in 1..size:
    if randChars:
      line = genHexString(1024)
    if linefeed:
      line[1023] = '\l'
    newFile.write(line)
  newFile.close()


# Main procedure
proc main() =
  randomize()
  let opts = parseOpts()
  createFile(opts.filename, opts.size, opts.random, opts.linefeed)


when isMainModule:
  main()
