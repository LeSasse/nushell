let catalog_url = "https://www.gutenberg.org/cache/epub/feeds/pg_catalog.csv"


# A utility to search the gutenberg catalog and download books in multiple formats.
def gutenberg [] {}

# Search the gutenberg catalog for a particular string.
def "gutenberg find" [search_term: string] {
  http get $catalog_url | find $search_term
}

# Download a book given the index.
def "gutenberg get" [
  index: int # gutenberg index which can be obtained using "gutenberg find". 
  --format (-f): string = "epub3.images" # Can be 'epub3', 'epub', or 'txt'.
  --noimages (-i) # Download epub with or without images. Has no effect im format is 'txt'.
  --name (-n): string # Which name to give the resulting file. Default: '($index).($format)'.
  
] {

  let ext = match $format {
    "epub" => {
      if $noimages {"noimages"} else {"images"}
    },
    "epub3" => {
      if $noimages {"noimages"} else {"images"}
    },
    "txt" => {
      "utf-8"
    },
    _ => {
      error make {
        msg: "Incorrect format given. Possible values are 'epub3', 'epub', and 'txt'",
        label: {
            text: "Incorrect format here.",
            span: (metadata $format).span
        }
    }
      
    }
  }

  let name = ($name | default $"($index).($format)")
  let download_url = $"https://www.gutenberg.org/ebooks/($index).($format).($ext)"
  print $"Downloading book ($index) as ($format) from ($download_url) to ($name)..."
  http get $download_url | save $name
}
