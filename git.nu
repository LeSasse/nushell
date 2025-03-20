
def gstats [] {
  git log --shortstat --oneline | grep -E "changed" | awk -F', ' '{
      files_changed = $1 ~ /file/ ? $1+0 : 0
      insertions = ($2 ~ /insertion/ ? $2+0 : 0)
      deletions = ($3 ~ /deletion/ ? $3+0 : 0)
      print files_changed "," insertions "," deletions
    }' | from csv -n | rename files_changed lines_inserted lines_deleted
}

# Parse git log into a structured table.
def glog [] {
  let stats = gstats
  (git log --pretty="%h»¦«%aN»¦«%aE»¦«%aD»¦«%s»"
    | lines
    | split column "»¦«" commit name email date subject
    | upsert date {|d| $d.date | into datetime}
    | merge $stats
    | move subject --after lines_deleted
  )
}
