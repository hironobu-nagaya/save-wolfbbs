#!/bin/awk -f
# Begin libexec/generate-select-day.awk

function getValue(KEY) {
  INDEX = match($0, KEY "=\"[^\"]*\"")
  return substr($0, INDEX + length(KEY) + 2, index(substr($0, INDEX + length(KEY) + 3), "\""))
}

/^<main/ {
  DAY = substr(getValue("id"), 5)
  switch(getValue("class")) {
    case "prologue": MESSAGE = "プロローグ"; break
    case "epilogue": MESSAGE = "エピローグ"; break
    case "order": MESSAGE = "終了"; break
    default: MESSAGE = DAY "日目"; break
  }
  printf("<a id=\"select-day-" DAY "\"" (DAY == 0 ? " class=\"selected\"" : "") ">" MESSAGE "</a>")
}

# End libexec/generate-select-day.awk
