# Read and convert an azure notebook to a python file
def "from aznb" [] {
  ($in 
    | from json
    | get properties
    | get cells
    | each {
      |e| if $e.cellType == "code" { $e.source  } else { ($e.source | each {
        |inner| "## " + $inner}) 
      }
    }
    | each { str join "" }
    | str join "\n\n"
  )
}
