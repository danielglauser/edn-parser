#!/bin/bash
##########################################################
# Herein lie a collection of, weak, incomplete, brittle parsers for
# Clojure's EDN https://github.com/edn-format/edn
# Beware all yea who enter.
##########################################################

# functions take a string and a function they are supposed to call
# when they find a match. Functions return what isn't matched.
# assumptions: keys and values appear on the same line

parse_open_map_ret=''
parse_open_map () {
  str=$1

  echo "digesting $str"
  parse_open_map_ret=$str
  if [[ $str == \{* ]]; then
    echo "found map open"
    parse_open_map_ret=${str:1}
  fi
}

parse_open_map '{:delete-uploads? false'
echo "parse_open_map returned: $parse_open_map_ret"

keyword=''
parse_keyword_ret=''
parse_keyword () {
  str=$1

  echo "digesting $str"
  parse_keyword_ret=$str
  if [[ $str == \:* ]]; then
    echo "found keyword"
    delim_idx=`expr index "$str" ' '`
    echo "delim idx: $delim_idx"
    if [[ ! $delim_idx > 0 ]]; then
      delim_idx=${#str}
    fi
    keyword=${str:0:$delim_idx}
    parse_keyword_ret=${str:$delim_idx:${#str}}
  fi
}

parse_keyword "${parse_open_map_ret}"
echo "keyword found: $keyword"
echo "parse_keyword returned: $parse_keyword_ret"

value=''
parse_value_ret=''
parse_value () {
  str=$1

  echo "digesting $str"
  comment_idx=`expr index "$str" '#_'`
  echo "comment idx: $comment_idx"
  if [[ ! $comment_idx > 0 ]]; then
    comment_idx=${#str}
  fi
  value=${str:0:$comment_idx}
}

parse_value "${parse_keyword_ret}"
echo "value: ${value}"
