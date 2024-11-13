
# Get a summary of descriptive statistics for an input table.
def "math describe" [] {
  let avg_result = $in | math avg | transpose | rename variable_name avg
  let median_result = $in | math median | transpose | rename variable_name median
  let stddev_result = $in | math stddev | transpose | rename variable_name stddev
  let min_result = $in | math min | transpose | rename variable_name min
  let max_result = $in | math max | transpose | rename variable_name max

  ($avg_result
    | join -o $median_result variable_name
    | join -o $stddev_result variable_name
    | join -o $min_result variable_name
    | join -o $max_result variable_name
    )
}


def "greet" [] {
  "Hello World!"
}


def "wp" [] {
  which python | get path.0
}
