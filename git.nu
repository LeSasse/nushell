
# Parse git log into a structured table.
def glog [] {
  (git log --pretty="%h»¦«%s»¦«%aN»¦«%aE»¦«%aD"
    | lines
    | split column "»¦«" commit subject name email date
    | upsert date {|d| $d.date | into datetime}
  )
}
