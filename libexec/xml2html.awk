#!/bin/awk -f
# Begin libexec/xml2html.awk

BEGIN {
  MESSAGE = ""
  READING_TEXT = 0
  MAIN_COUNT = 0
  PLAYER_COUNT = 0
  PUBLIC_MESSAGE_COUNT = 0
  TIME_REFERENCE_COUNT = 0
  MESSAGE_REFERENCE_COUNT = 0
  TIME_REFERENCE_REGEX = "([01０１]?[0-9０-９][dDｄＤ])?([0-2０-２]?[0-9０-９])[:：]?[0-5０-５][0-9０-９]"
  MESSAGE_REFERENCE_REGEX = "((&gt;)|＞){1,2}[1-9１-９][0-9０-９]*"
  ELEMENT_REGEX = "<[^>]*>"
  FOOTER = "WolfBBS by <a href=\"http://ninjinix.com/\">ninjin</a>"
}

function appendMessage(MESSAGE) {
  return MESSAGE gensub(/(<\/li>|<li\/>)/, "<br>", "g", gensub(/<li>/, "", "g"))
}

function convertDigit(DIGITS) {
  return gensub(/９/, "9", "g", gensub(/８/, "8", "g", gensub(/７/, "7", "g", gensub(/６/, "6", "g", gensub(/５/, "5", "g", gensub(/４/, "4", "g", gensub(/３/, "3", "g", gensub(/２/, "2", "g", gensub(/１/, "1", "g", gensub(/０/, "0", "g", DIGITS))))))))))
}

function cleanupMessage(MESSAGE) {
  return substr(MESSAGE, 0, length(MESSAGE) - 4);
}

function decorateMessage(MESSAGE) {
  return LAND_ID == "wolfg" ? decorateWolfgMessage(cleanupMessage(MESSAGE)) : decorateWolfMessage(cleanupMessage(MESSAGE))
}

function decorateWolfMessage(MESSAGE) {
  REMAIN_MESSAGE = MESSAGE
  MESSAGE = ""
  while (REMAIN_MESSAGE ~ TIME_REFERENCE_REGEX) {
    ELEMENT_START_INDEX = match(REMAIN_MESSAGE, ELEMENT_REGEX)
    ELEMENT_END_INDEX = ELEMENT_START_INDEX + RLENGTH
    INDEX = match(REMAIN_MESSAGE, TIME_REFERENCE_REGEX)
    if (ELEMENT_START_INDEX != 0 && (ELEMENT_END_INDEX < INDEX || (ELEMENT_START_INDEX <= INDEX && INDEX <= ELEMENT_END_INDEX))) {
      MESSAGE = MESSAGE substr(REMAIN_MESSAGE, 0, ELEMENT_END_INDEX - 1)
      REMAIN_MESSAGE = substr(REMAIN_MESSAGE, ELEMENT_END_INDEX)
      continue
    }
    TIME_REFERENCE_START_INDEX = INDEX
    DAY_CHARACTER_INDEX = match(substr(REMAIN_MESSAGE, INDEX, 3), /[dDｄＤ]/)
    if (DAY_CHARACTER_INDEX) {
      DAY = int(convertDigit(substr(REMAIN_MESSAGE, INDEX, DAY_CHARACTER_INDEX - 1)))
      INDEX += DAY_CHARACTER_INDEX
    } else {
      DAY = MAIN_COUNT - 1
    }
    TIME_CHARACTER_INDEX = match(substr(REMAIN_MESSAGE, INDEX, 3), /[:：]/)
    if (TIME_CHARACTER_INDEX) {
      HOUR = sprintf("%02d", int(convertDigit(substr(REMAIN_MESSAGE, INDEX, TIME_CHARACTER_INDEX - 1))) % 24)
      INDEX += TIME_CHARACTER_INDEX
      MINUTE = convertDigit(substr(REMAIN_MESSAGE, INDEX, 2))
      INDEX += 2
      if (MINUTE !~ /[0-5][0-9]/) {
        MINUTE = sprintf("%02d", int(substr(MINUTE, 0, 1)))
        INDEX -= 1
      }
    } else {
      TIME = convertDigit(substr(REMAIN_MESSAGE, INDEX, 4))
      if (TIME ~ /[0-2][0-9][0-5][0-9]/) {
        HOUR = sprintf("%02d", int(substr(TIME, 0, 2)) % 24)
        MINUTE = substr(TIME, 3, 2)
        INDEX += 4
      } else {
        HOUR = sprintf("%02d", int(substr(TIME, 0, 1)))
        MINUTE = substr(TIME, 2, 2)
        INDEX += 3
      }
    }
    TIME_REFERENCE_LENGTH = INDEX - TIME_REFERENCE_START_INDEX
    MESSAGE = MESSAGE substr(REMAIN_MESSAGE, 0, TIME_REFERENCE_START_INDEX - 1) "<a id=\"time-reference-" ++TIME_REFERENCE_COUNT "\" class=\"time-" DAY "d" HOUR MINUTE "\">" substr(REMAIN_MESSAGE, TIME_REFERENCE_START_INDEX, TIME_REFERENCE_LENGTH) "</a>"
    REMAIN_MESSAGE = substr(REMAIN_MESSAGE, INDEX)
  }
  return MESSAGE REMAIN_MESSAGE
}

function decorateWolfgMessage(MESSAGE) {
  REMAIN_MESSAGE = MESSAGE
  MESSAGE = ""
  while (REMAIN_MESSAGE ~ TIME_REFERENCE_REGEX) {
    ELEMENT_START_INDEX = match(REMAIN_MESSAGE, ELEMENT_REGEX)
    ELEMENT_END_INDEX = ELEMENT_START_INDEX + RLENGTH
    MESSAGE_REFERENCE_START_INDEX = match(REMAIN_MESSAGE, MESSAGE_REFERENCE_REGEX)
    MESSAGE_REFERENCE_END_INDEX = MESSAGE_REFERENCE_START_INDEX + RLENGTH
    INDEX = match(REMAIN_MESSAGE, TIME_REFERENCE_REGEX)
    if (ELEMENT_START_INDEX != 0 && MESSAGE_REFERENCE_START_INDEX != 0 && (ELEMENT_END_INDEX < INDEX || (ELEMENT_START_INDEX <= INDEX && INDEX <= ELEMENT_END_INDEX)) && (MESSAGE_REFERENCE_END_INDEX < INDEX || (MESSAGE_REFERENCE_START_INDEX <= INDEX && INDEX <= MESSAGE_REFERENCE_END_INDEX))) {
      if (ELEMENT_START_INDEX < MESSAGE_REFERENCE_START_INDEX) {
        MESSAGE = MESSAGE substr(REMAIN_MESSAGE, 0, MESSAGE_REFERENCE_END_INDEX - 1)
        REMAIN_MESSAGE = substr(REMAIN_MESSAGE, MESSAGE_REFERENCE_END_INDEX)
        continue
      } else {
        MESSAGE = MESSAGE substr(REMAIN_MESSAGE, 0, ELEMENT_END_INDEX - 1)
        REMAIN_MESSAGE = substr(REMAIN_MESSAGE, ELEMENT_END_INDEX)
        continue
      }
    }
    if (ELEMENT_START_INDEX != 0 && (ELEMENT_END_INDEX < INDEX || (ELEMENT_START_INDEX <= INDEX && INDEX <= ELEMENT_END_INDEX))) {
      MESSAGE = MESSAGE substr(REMAIN_MESSAGE, 0, ELEMENT_END_INDEX - 1)
      REMAIN_MESSAGE = substr(REMAIN_MESSAGE, ELEMENT_END_INDEX)
      continue
    }
    if (MESSAGE_REFERENCE_START_INDEX != 0 && (MESSAGE_REFERENCE_END_INDEX < INDEX || (MESSAGE_REFERENCE_START_INDEX <= INDEX && INDEX <= MESSAGE_REFERENCE_END_INDEX))) {
      MESSAGE = MESSAGE substr(REMAIN_MESSAGE, 0, MESSAGE_REFERENCE_END_INDEX - 1)
      REMAIN_MESSAGE = substr(REMAIN_MESSAGE, MESSAGE_REFERENCE_END_INDEX)
      continue
    }
    TIME_REFERENCE_START_INDEX = INDEX
    DAY_CHARACTER_INDEX = match(substr(REMAIN_MESSAGE, INDEX, 3), /[dDｄＤ]/)
    if (DAY_CHARACTER_INDEX) {
      DAY = int(convertDigit(substr(REMAIN_MESSAGE, INDEX, DAY_CHARACTER_INDEX - 1)))
      INDEX += DAY_CHARACTER_INDEX
    } else {
      DAY = MAIN_COUNT - 1
    }
    TIME_CHARACTER_INDEX = match(substr(REMAIN_MESSAGE, INDEX, 3), /[:：]/)
    if (TIME_CHARACTER_INDEX) {
      HOUR = sprintf("%02d", int(convertDigit(substr(REMAIN_MESSAGE, INDEX, TIME_CHARACTER_INDEX - 1))) % 24)
      INDEX += TIME_CHARACTER_INDEX
      MINUTE = convertDigit(substr(REMAIN_MESSAGE, INDEX, 2))
      INDEX += 2
      if (MINUTE !~ /[0-5][0-9]/) {
        MINUTE = sprintf("%02d", int(substr(MINUTE, 0, 1)))
        INDEX -= 1
      }
    } else {
      TIME = convertDigit(substr(REMAIN_MESSAGE, INDEX, 4))
      if (TIME ~ /[0-2][0-9][0-5][0-9]/) {
        HOUR = sprintf("%02d", int(substr(TIME, 0, 2)) % 24)
        MINUTE = substr(TIME, 3, 2)
        INDEX += 4
      } else {
        HOUR = sprintf("%02d", int(substr(TIME, 0, 1)))
        MINUTE = substr(TIME, 2, 2)
        INDEX += 3
      }
    }
    TIME_REFERENCE_LENGTH = INDEX - TIME_REFERENCE_START_INDEX
    MESSAGE = MESSAGE substr(REMAIN_MESSAGE, 0, TIME_REFERENCE_START_INDEX - 1) "<a id=\"time-reference-" ++REFERENCE_COUNT "\" class=\"time-" DAY "d" HOUR MINUTE "\">" substr(REMAIN_MESSAGE, TIME_REFERENCE_START_INDEX, TIME_REFERENCE_LENGTH) "</a>"
    REMAIN_MESSAGE = substr(REMAIN_MESSAGE, INDEX)
  }

  REMAIN_MESSAGE = MESSAGE REMAIN_MESSAGE
  MESSAGE = ""
  while (REMAIN_MESSAGE ~ MESSAGE_REFERENCE_REGEX) {
    ELEMENT_START_INDEX = match(REMAIN_MESSAGE, ELEMENT_REGEX)
    ELEMENT_END_INDEX = ELEMENT_START_INDEX + RLENGTH
    MESSAGE_REFERENCE_START_INDEX = match(REMAIN_MESSAGE, MESSAGE_REFERENCE_REGEX)
    MESSAGE_REFERENCE_LENGTH = RLENGTH
    MESSAGE_REFERENCE_END_INDEX = MESSAGE_REFERENCE_START_INDEX + MESSAGE_REFERENCE_LENGTH
    if (ELEMENT_START_INDEX != 0 && ELEMENT_START_INDEX <= MESSAGE_REFERENCE_START_INDEX && MESSAGE_REFERENCE_START_INDEX <= ELEMENT_END_INDEX) {
      MESSAGE = MESSAGE substr(REMAIN_MESSAGE, 0, ELEMENT_END_INDEX - 1)
      REMAIN_MESSAGE = substr(REMAIN_MESSAGE, ELEMENT_END_INDEX)
      continue
    }
    MESSAGE_REFERENCE_NUMBER = convertDigit(gensub(/^((&gt;)|＞){1,2}/, "", 1, substr(REMAIN_MESSAGE, MESSAGE_REFERENCE_START_INDEX, MESSAGE_REFERENCE_LENGTH)))
    MESSAGE = MESSAGE substr(REMAIN_MESSAGE, 0, MESSAGE_REFERENCE_START_INDEX - 1) "<a id=\"message-reference-" ++MESSAGE_REFERENCE_COUNT "\" class=\"message-" MESSAGE_REFERENCE_NUMBER "\">" substr(REMAIN_MESSAGE, MESSAGE_REFERENCE_START_INDEX, MESSAGE_REFERENCE_LENGTH) "</a>"
    REMAIN_MESSAGE = substr(REMAIN_MESSAGE, MESSAGE_REFERENCE_END_INDEX)
  }
  return MESSAGE REMAIN_MESSAGE
}

function hasValue(KEY) {
  return $0 ~ KEY "=\"[^\"]*\""
}

function getValue(KEY) {
  INDEX = match($0, KEY "=\"[^\"]*\"")
  return substr($0, INDEX + length(KEY) + 2, index(substr($0, INDEX + length(KEY) + 3), "\""))
}

/^<village$/,/^>$/ {
  if (!/^>$/) {
    if (hasValue("fullName")) {
      VILLAGE_FULL_NAME = getValue("fullName")
    }
    if (hasValue("formalName")) {
      FORMAL_NAME = getValue("formalName")
    }
    if (hasValue("graveIconURI")) {
      GRAVE_ICON_URI = "plugin_wolf/img/" gensub(/.*\//, "", 1, getValue("graveIconURI"))
    }
    if (hasValue("landId")) {
      LAND_ID = getValue("landId")
    }
  } else {
    print "<html lang=\"ja\"><head><meta charset=\"utf-8\"><meta name=\"format-detection\" content=\"telephone=no, email=no, address=no\"><title>" FORMAL_NAME " " VILLAGE_FULL_NAME "</title><link rel=\"icon\" type=\"image/vnd.microsoft.icon\" href=\"plugin_wolf/img/favicon.ico\" sizes=\"16x16\"><link rel=\"stylesheet\" type=\"text/css\" href=\"plugin_wolf/css/wolfbbs.css\"><script src=\"plugin_wolf/js/jquery.js\"></script><script src=\"plugin_wolf/js/wolfbbs.js\"/></script></head><body>"
  }
}

/^<avatar/,/^\/>$/ {
  if (!/^\/>$/) {
    if (hasValue("avatarId")) {
      AVATAR_ID = getValue("avatarId")
    }
    if (hasValue("fullName")) {
      FULL_NAME = getValue("fullName")
    }
    if (hasValue("shortName")) {
      SHORT_NAME = getValue("shortName")
    }
    if (hasValue("faceIconURI")) {
      FACE_ICON_URI = "plugin_wolf/img/" gensub(/.*\//, "", 1, getValue("faceIconURI"))
    }
  } else {
    AVATARS[AVATAR_ID, 1] = FULL_NAME
    AVATARS[AVATAR_ID, 2] = SHORT_NAME
    AVATARS[AVATAR_ID, 3] = FACE_ICON_URI
  }
}

/^<period/,/^>$/ {
  if (!/^>$/) {
    if (hasValue("type")) {
      TYPE = getValue("type")
    }
    if (hasValue("day")) {
      DAY = getValue("day")
    }
    if (hasValue("nextCommitDay")) {
      split(substr(getValue("nextCommitDay"), 3, 7), NEXT_COMMIT_DAY, /-/)
    }
    if (hasValue("commitTime")) {
      COMMIT_TIME = substr(getValue("commitTime"), 0, 5)
    }
  } else {
    MAIN_COUNT++
    if (DAY == 0) {
      print "<header><figure><img class=\"title\" src=\"./plugin_wolf/img/title.jpg\"/></figure><p>" VILLAGE_FULL_NAME "<strong>（" int(NEXT_COMMIT_DAY[1]) "/" int(NEXT_COMMIT_DAY[2]) " " COMMIT_TIME  " に更新）</strong></header><nav><p id=\"select-day\"></p><span id=\"select-mode\">mode :<a id=\"select-public\">人</a><a id=\"select-wolf\">狼</a><a id=\"select-grave\">墓</a><a id=\"select-all\" class=\"selected\">全</a></span></nav>"
    }
    print "<main id=\"day-" DAY "\" class=\"" TYPE "\"" (DAY == 0 ? "" : " style=\"display: none;\"") ">"
  }
}

/^<startEntry>$/,/^<\/startEntry>$/ {
  if (!/^(<li>.*<\/li>|<li\/>|<\/startEntry>)$/) {
    next
  }
  if (!/^<\/startEntry>$/) {
    MESSAGE = appendMessage(MESSAGE)
  } else {
    print "<article><section><p class=\"announce\">" cleanupMessage(MESSAGE) "</p></section></article>"
    MESSAGE = ""
  }
}

/^<startMirror>$/,/^<\/startMirror>$/ {
  if (!/^(<li>.*<\/li>|<li\/>|<\/startMirror>)$/) {
    next
  }
  if (!/^<\/startMirror>$/) {
    MESSAGE = appendMessage(MESSAGE)
  } else {
    print "<article><section><p class=\"announce\">" cleanupMessage(MESSAGE) "</p></section></article>"
    MESSAGE = ""
  }
}

/^<startAssault>$/,/^<\/startAssault>$/ {
  if (!/$(<li>.*<\/li>|<li\/>|<\/startAssault>$)/) {
    next
  }
  if (!/^<\/startAssault>$/) {
    MESSAGE = appendMessage(MESSAGE)
  } else {
    print "<article><section><p class=\"announce\">" cleanupMessage(MESSAGE) "</p></section></article>"
    MESSAGE = ""
  }
}

/^<openRole>$/,/^<\/openRole>$/ {
  if (!/^(<li>.*<\/li>|<li\/>|<\/openRole>)$/) {
    next
  }
  if (!/^<\/openRole>$/) {
    MESSAGE = appendMessage(MESSAGE)
  } else {
    print "<article><section><p class=\"announce\">" cleanupMessage(MESSAGE) "</p></section></article>"
    MESSAGE = ""
  }
}

/^<openEntry>$/,/^<\/openEntry>$/ {
  if (!/(<li>.*<\/li>|<li\/>|^<\/openEntry>$)/) {
    next
  }
  if (!/^<\/openEntry>$/) {
    MESSAGE = appendMessage(MESSAGE)
  } else {
    print "<article><section><p class=\"announce\">" cleanupMessage(MESSAGE) "</p></section></article>"
    MESSAGE = ""
  }
}

/^<onStage/,/^<\/onStage>$/ {
  if (!/^(<li>.*<\/li>|<li\/>|<\/onStage>)$/) {
    next
  }
  if (!/^<\/onStage>$/) {
    MESSAGE = appendMessage(MESSAGE)
  } else {
    print "<article><section><p class=\"announce\">" cleanupMessage(MESSAGE) "</p></section></article>"
    MESSAGE = ""
  }
}

/^<judge/,/^<\/judge>$/ {
  if (!/^(<li>.*<\/li>|<li\/>|<\/judge>)$/) {
    next
  }
  if (!/^<\/judge>$/) {
    MESSAGE = appendMessage(MESSAGE)
  } else {
    print "<article class=\"private\"><section><p class=\"extra\">" cleanupMessage(MESSAGE) "</p></section></article>"
    MESSAGE = ""
  }
}

/^<counting /,/^<\/counting>$/ {
  if (!/^(<li>.*<\/li>|<li\/>|<\/counting>)$/) {
    next
  }
  if (!/^<\/counting>$/) {
    MESSAGE = appendMessage(MESSAGE)
  } else {
    print "<article><section><p class=\"announce\">" cleanupMessage(MESSAGE) "</p></section></article>"
    MESSAGE = ""
  }
}

/^<counting2>$/,/^<\/counting2>$/ {
  if (!/^(<li>.*<\/li>|<li\/>|<\/counting2>)$/) {
    next
  }
  if (!/^<\/counting2>$/) {
    MESSAGE = appendMessage(MESSAGE)
  } else {
    print "<article class=\"private\"><section><p class=\"extra\">" cleanupMessage(MESSAGE) "</p></section></article>"
    MESSAGE = ""
  }
}

/^<execution/,/^<\/execution>$/ {
  if (!/^(<li>.*<\/li>|<li\/>|<\/execution>)$/) {
    next
  }
  if (!/^<\/execution>$/) {
    MESSAGE = appendMessage(MESSAGE)
  } else {
    print "<article><section><p class=\"announce\">" cleanupMessage(MESSAGE) "</p></section></article>"
    MESSAGE = ""
  }
}

/^<guard/,/^<\/guard>$/ {
  if (!/^(<li>.*<\/li>|<li\/>|<\/guard>)$/) {
    next
  }
  if (!/^<\/guard>$/) {
    MESSAGE = appendMessage(MESSAGE)
  } else {
    print "<article class=\"private\"><section><p class=\"extra\">" cleanupMessage(MESSAGE) "</p></section></article>"
    MESSAGE = ""
  }
}

/^<murdered/,/^<\/murdered>$/ {
  if (!/^(<li>.*<\/li>|<li\/>|<\/murdered>$)/) {
    next
  }
  if (!/^<\/murdered>$/) {
    MESSAGE = appendMessage(MESSAGE)
  } else {
    print "<article><section><p class=\"announce\">" cleanupMessage(MESSAGE) "</p></section></article>"
    MESSAGE = ""
  }
}

/^<noMurder>$/,/^<\/noMurder>$/ {
  if (!/^(<li>.*<\/li>|<li\/>|<\/noMurder>)$/) {
    next
  }
  if (!/^<\/onMurder>$/) {
    MESSAGE = appendMessage(MESSAGE)
  } else {
    print "<article><section><p class=\"announce\">" cleanupMessage(MESSAGE) "</p></section></article>"
    MESSAGE = ""
  }
}

/^<survivor>$/,/^<\/survivor>$/ {
  if (!/^(<li>.*<\/li>|<li\/>|<\/survivor>)$/) {
    next
  }
  if (!/^<\/survivor>$/) {
    MESSAGE = appendMessage(MESSAGE)
  } else {
    print "<article><section><p class=\"announce\">" cleanupMessage(MESSAGE) "</p></section></article>"
    MESSAGE = ""
  }
}

/^<vanish/,/^<\/vanish>$/ {
  if (!/^(<li>.*<\/li>|<li\/>|<\/vanish>)$/) {
    next
  }
  if (!/^<\/vanish>$/) {
    MESSAGE = appendMessage(MESSAGE)
  } else {
    print "<article><section><p class=\"announce\">" cleanupMessage(MESSAGE) "</p></section></article>"
    MESSAGE = ""
  }
}

/^<suddenDeath/,/^<\/suddenDeath>$/ {
  if (!/^(<li>.*<\/li>|<li\/>|<\/suddenDeath>)$/) {
    next
  }
  if (!/^<\/suddenDeath>$/) {
    MESSAGE = appendMessage(MESSAGE)
  } else {
    print "<article><section><p class=\"announce\">" cleanupMessage(MESSAGE) "</p></section></article>"
    MESSAGE = ""
  }
}

/^<winVillage>$/,/^<\/winVillage>$/ {
  if (!/^(<li>.*<\/li>|<li\/>|<\/winVillage>)$/) {
    next
  }
  if (!/^<\/winVillage>$/) {
    MESSAGE = appendMessage(MESSAGE)
  } else {
    print "<article><section><p class=\"announce\">" cleanupMessage(MESSAGE) "</p></section></article>"
    MESSAGE = ""
  }
}

/^<winWolf>$/,/^<\/winWolf>$/ {
  if (!/^(<li>.*<\/li>|<li\/>|<\/winWolf>)$/) {
    next
  }
  if (!/^<\/winWolf>$/) {
    MESSAGE = appendMessage(MESSAGE)
  } else {
    print "<article><section><p class=\"announce\">" cleanupMessage(MESSAGE) "</section></article>"
    MESSAGE = ""
  }
}

/^<playerList>$/,/^<\/playerList>$/ {
  if (!/^(<li>.*<\/li>|<li\/>|<playerInfo.*\/>|<\/playerList>)$/) {
    next
  }
  if (!/^<\/playerList>$/) {
    if (/^<playerInfo.*\/>$/) {
      if (!/uri=".*"/) {
        next
      }
      if (hasValue("playerId")) {
        PLAYER_ID = getValue("playerId")
      }
      if (hasValue("uri")) {
        URI = getValue("uri")
      }

      for (I = 1; I <= length(PLAYERS); I++) {
        PLAYER_ID_START_INDEX = match(PLAYERS[I], "（.*）") + 1
        PLAYER_ID_LENGTH = RLENGTH - 2
        PLAYER_ID_END_INDEX = PLAYER_ID_START_INDEX + PLAYER_ID_LENGTH
        if (PLAYER_ID == substr(PLAYERS[I], PLAYER_ID_START_INDEX, PLAYER_ID_LENGTH)) {
          PLAYERS[I] = substr(PLAYERS[I], 0, PLAYER_ID_START_INDEX - 1) "<a class=\"player-url\" href=\"" URI "\">" substr(PLAYERS[I], PLAYER_ID_START_INDEX, PLAYER_ID_LENGTH) "</a>" substr(PLAYERS[I], PLAYER_ID_END_INDEX)
          break
        }
      }
    } else {
      PLAYERS[++PLAYER_COUNT] = appendMessage()
    }
  } else {
    print "<article><section class=\"announce\"><span>"
    for (I = 1; I <= length(PLAYERS); I++) {
      print PLAYERS[I]
    }
    print "</span></section></article>"
  }
}

/^<assault/,/^<\/assault>$/ {
  if(!READING_TEXT) {
    if (hasValue("byWhom")) {
      BY_WHOM = getValue("byWhom")
    }
    if (hasValue("time")) {
      TIME = substr(getValue("time"), 0, 5)
    }
    if (/^ *>$/) {
      READING_TEXT = 1
      next
    }
  } else {
    if (!/^<\/assault>$/) {
      if (!/^(<li>.*<\/li>$|<li\/>)$/) {
        next
      }
      MESSAGE = appendMessage(MESSAGE)
    } else {
      print "<article class=\"wolf\"><header>" AVATARS[BY_WHOM, 1] "<span class=\"time\">" TIME "</span></header><section><figure><img src=\"./" AVATARS[BY_WHOM, 3] "\"/></figure><p class=\"wolf\">" cleanupMessage(MESSAGE) "</p></section></article>"
      MESSAGE = ""
      READING_TEXT = 0
    }
  }
}

/^<talk/,/^<\/talk>$/ {
  if(!READING_TEXT) {
    if (hasValue("type")) {
      TYPE = getValue("type")
    }
    if (hasValue("avatarId")) {
      AVATAR_ID = getValue("avatarId")
    }
    if (hasValue("xname")) {
      XNAME = getValue("xname")
    }
    if (hasValue("time")) {
      TIME = substr(getValue("time"), 0, 5)
    }
    if (/^>$/) {
      READING_TEXT = 1
      next
    }
  } else {
    if (!/^<\/talk>$/) {
      if (!/^(<li>.*<\/li>|<li\/>)$/) {
        next
      }
      MESSAGE = appendMessage(MESSAGE)
    } else {
      HANDLE_PUBLIC_MESSAGE_COUNT = LAND_ID == "wolfg" && TYPE == "public"
      if (HANDLE_PUBLIC_MESSAGE_COUNT) {
        PUBLIC_MESSAGE_COUNT++
      }
      print "<article id=\"" XNAME "\" class=\"" (TYPE != "public" ? TYPE " " : "") "time-" (MAIN_COUNT - 1) "d" gensub(/:/, "", 1, TIME) (HANDLE_PUBLIC_MESSAGE_COUNT ? " message-" PUBLIC_MESSAGE_COUNT : "") "\"><header>" (HANDLE_PUBLIC_MESSAGE_COUNT ? "<span class=\"message-number\">" PUBLIC_MESSAGE_COUNT ".</span>" : "") "<span>" AVATARS[AVATAR_ID,1] "</span><span class=\"time\">" TIME "</span></header><section><figure><img src=\"./" (TYPE == "grave" ? GRAVE_ICON_URI : AVATARS[AVATAR_ID,3]) "\"/></figure><p class=\"" TYPE "\">" decorateMessage(MESSAGE) "</p></section></article>"
      MESSAGE = ""
      READING_TEXT = 0
    }
  }
}

/^<\/period>$/ {
  print "<a>次の日へ</a></main>"
}

/^<\/village>$/ {
    print "<main id=\"day-" MAIN_COUNT "\" class=\"order\" style=\"display: none;\"><article><section><p class=\"order\">終了しました。</p></section></article></main><footer>" FOOTER "</footer></body></html>"
}

# End libexec/xml2html.awk
