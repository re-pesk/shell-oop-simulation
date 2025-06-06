#! /usr/bin/env -S fish

. ./_multimap.fish

function test.assert ()
  set --local function_name "$argv[1]"
  set --local result "$argv[2]"
  set --local expected "$argv[3]"
  [ "$result" = "$expected" ] && true && return 0
  echo "Error in '$function_name'! Result"\n"'$result'"\n"!="\n"'$expected'!"\n >&2
  false
end

function test.MM.items
    set -l aa one abc=bcd two --nana=mama one.person=John\ Doe three other\ person="Jane Roe"

    set -l expected one abc=bcd two --nana=mama one.person=John\ Doe three other\ person="Jane Roe"
    set -l result (MM.items --output-type=element --aa-name=aa)
    test.assert (status function) "$result" "$expected"

    set -l expected 1=one abc=bcd 2=two --nana=mama one.person=John\ Doe 3=three other\ person="Jane Roe"
    set -l result (MM.items --output-type=entry --aa-name=aa)
    test.assert (status function) "$result" "$expected"

    set -l expected one bcd two mama John\ Doe three "Jane Roe"
    set -l result (MM.items --output-type=value --aa-name=aa)
    test.assert (status function) "$result" "$expected"

    set -l expected 1 abc 2 --nana one.person 3 other\ person
    set -l result (MM.items --output-type=key --aa-name=aa)
    test.assert (status function) "$result" "$expected"

    set -l aa 1=one abc=bcd 2=two --nana=mama one.person=John\ Doe 3=three other\ person="Jane Roe"
    set -l expected one abc=bcd two --nana=mama one.person=John\ Doe three other\ person="Jane Roe"
    set -l result (MM.items --output-type=element --aa-name=aa)
    test.assert (status function) "$result" "$expected"

    set -l aa one abc=bcd two --nana=mama one.person=John\ Doe 3=three other\ person="Jane Roe" 4=four
    set -l expected one abc=bcd two --nana=mama one.person=John\ Doe three other\ person="Jane Roe" four
    set -l result (MM.items --output-type=element --aa-name=aa)
    test.assert (status function) "$result" "$expected"

    set -l aa one abc=bcd two --nana=mama one.person=John\ Doe 3=three other\ person="Jane Roe" 14=four
    set -l expected 1=one abc=bcd 2=two --nana=mama one.person=John\ Doe 3=three other\ person="Jane Roe" 4=four
    set -l result (MM.items --output-type=entry --aa-name=aa)
    test.assert (status function) "$result" "$expected"

    set -l aa one abc=bcd two --nana=mama one.person=John\ Doe 3=three other\ person="Jane Roe" 14=four
    set -l expected 1 abc 2 --nana one.person 3 other\ person 4
    set -l result (MM.items --output-type=key --aa-name=aa)
    test.assert (status function) "$result" "$expected"
end

function test.MM.lastNumKey
    set -l aa one abc=bcd two --nana=mama one.person=John\ Doe three other\ person="Jane Roe"
    set -l expected 3
    set -l result (MM.lastNumKey --aa-name=aa)
    test.assert (status function) "$result" "$expected"
end

function test.MM.indexesOf
    set -l aa one abc=bcd two --nana=mama one.person=John\ Doe three other\ person="Jane Roe"
    set -l expected 1 3 5 6

    set -l result (MM.indexesOf --input-type=element --aa-name=aa one two one.person=John\ Doe three 4=eleven)
    test.assert (status function) "$result" "$expected"

    set -l result (MM.indexesOf --input-type=entry --aa-name=aa 1=one 2=two one.person=John\ Doe 3=three 4=eleven)
    test.assert (status function) "$result" "$expected"

    set -l result (MM.indexesOf --input-type=value --aa-name=aa one two John\ Doe three eleven)
    test.assert (status function) "$result" "$expected"
 
    set -l result (MM.indexesOf --input-type=key --aa-name=aa 1 2 one.person 3 4)
    test.assert (status function) "$result" "$expected"
end

function test.MM.itemsByIndexes
    set -l aa one abc=bcd two --nana=mama one.person=John\ Doe three other\ person="Jane Roe"

    set -l expected one two one.person=John\ Doe three
    set -l result (MM.itemsByIndexes --output-type=element --aa-name=aa 1 3 5 6)
    test.assert (status function) "$result" "$expected"

    set -l expected 1=one 2=two one.person=John\ Doe 3=three
    set -l result (MM.itemsByIndexes --output-type=entry --aa-name=aa 1 3 5 6)
    test.assert (status function) "$result" "$expected"

    set -l expected one two John\ Doe three
    set -l result (MM.itemsByIndexes --output-type=value --aa-name=aa 1 3 5 6)
    test.assert (status function) "$result" "$expected"

    set -l expected 1 2 one.person 3
    set -l result (MM.itemsByIndexes --output-type=key --aa-name=aa 1 3 5 6)
    test.assert (status function) "$result" "$expected"
end

function test.MM.itemsByKeys
    set -l aa one abc=bcd two --nana=mama one.person=John\ Doe three other\ person="Jane Roe"

    set -l expected one two one.person=John\ Doe three
    set -l result (MM.itemsByItems --input-type=key --output-type=element --aa-name=aa 1 2 one.person 3)
    test.assert (status function) "$result" "$expected"

    set -l expected 1=one 2=two one.person=John\ Doe 3=three
    set -l result (MM.itemsByItems --input-type=key --output-type=entry --aa-name=aa 1 2 one.person 3)
    test.assert (status function) "$result" "$expected"

    set -l expected one two John\ Doe three
    set -l result (MM.itemsByItems --input-type=key --output-type=value --aa-name=aa 1 2 one.person 3)
    test.assert (status function) "$result" "$expected"

    set -l expected 1 2 one.person 3
    set -l result (MM.itemsByItems --input-type=key --output-type=key --aa-name=aa 1 2 one.person 3)
    test.assert (status function) "$result" "$expected"
end

function test.MM.keysByItems
    set -l aa one abc=bcd two --nana=mama one.person=John\ Doe three other\ person="Jane Roe"

    set -l expected 1 2 one.person 3
    set -l result (MM.itemsByItems --input-type=element --output-type=key --aa-name=aa one two one.person=John\ Doe three)
    test.assert (status function) "$result" "$expected"

    set -l expected 1 2 one.person 3
    set -l result (MM.itemsByItems --input-type=entry --output-type=key --aa-name=aa 1=one 2=two one.person=John\ Doe 3=three)
    test.assert (status function) "$result" "$expected"

    set -l expected 1 2 one.person 3
    set -l result (MM.itemsByItems --input-type=value --output-type=key --aa-name=aa one two John\ Doe three)
    test.assert (status function) "$result" "$expected"

    set -l expected 1 2 one.person 3
    set -l result (MM.itemsByItems --input-type=key --output-type=key --aa-name=aa 1 2 one.person 3)
    test.assert (status function) "$result" "$expected"
end

function test.MM.remainingSet
    set -l aa one abc=bcd two --nana=mama one.person=John\ Doe three other\ person="Jane Roe" four five six seven
    set -l expected 2 4 6 8 10
    set -l result (MM.remainingSet --aa-name=aa 1 3 5 7 9 11)
    test.assert (status function) "$result" "$expected"
end

function test.MM.remainingIndexesOf
    set -l aa one abc=bcd two --nana=mama one.person=John\ Doe three other\ person="Jane Roe" four five six seven
    set -l expected 2 4 6 8 10
    set -l result (MM.remainingIndexesOf --input-type=key --aa-name=aa 1 2 one.person other\ person 5 7 11)
    test.assert (status function) "$result" "$expected"

    set -l expected 1 2 3 4 5 6 7 8 9 10 11
    set -l result (MM.remainingIndexesOf --input-type=key --aa-name=aa)
    test.assert (status function) "$result" "$expected"
end

function test.MM.remainingItems
    set -l aa one abc=bcd two --nana=mama one.person=John\ Doe three other\ person="Jane Roe" four five six seven

    set -l expected abc --nana 3 4 6
    set -l result (MM.remainingItems --input-type=key --output-type=key --aa-name=aa 1 2 one.person other\ person 5 7 11)
    test.assert (status function) "$result" "$expected"

    set -l expected bcd mama three four six
    set -l result (MM.remainingItems --input-type=key --output-type=value --aa-name=aa 1 2 one.person other\ person 5 7 11)
    test.assert (status function) "$result" "$expected"

    set -l expected 1 2 one.person other\ person 5 7
    set -l result (MM.remainingItems --input-type=value --output-type=key --aa-name=aa bcd mama three four six)
    test.assert (status function) "$result" "$expected"
end

function test.MM.setEntries
    set -l aa one abc=bcd two --nana=mama one.person=John\ Doe

    set -l expected one abc=bcd two --nana=mama one.person=John\ Doe three other\ person="Jane Roe" four five six seven
    set -l result (MM.setEntries --output-type=element --aa-name=aa 3=three other\ person="Jane Roe" 4=four 5=five 6=six 7=seven)
    test.assert (status function) "$result" "$expected"

    set -l expected one abc=bcd two --nana=tėtis one.person=John\ Doe three other\ person="Jane Roe" four five six seven
    set -l result (MM.setEntries --output-type=element --aa-name=aa 2=two --nana=tėtis 3=three other\ person="Jane Roe" 4=four 5=five 6=six 7=seven)
    test.assert (status function) "$result" "$expected"
end

function test.MM.setPairs
    set -l aa one abc=bcd two --nana=mama one.person=John\ Doe
    set -l expected one abc=bcd two --nana=mama one.person=John\ Doe three other\ person="Jane Roe" four five six seven
    set -l result (MM.setPairs --output-type=element --aa-name=aa -- 3 three other\ person "Jane Roe" 4 four 5 five 6 six 7 seven)
    test.assert (status function) "$result" "$expected"

    set -l expected one abc=bcd two --nana=mama one.person=John\ Doe three other\ person="Jane Roe" four five six seven
    set -l result (MM.setPairs --output-type=element --aa-name=aa -- 2 two 3 three other\ person "Jane Roe" 4 four 5 five 6 six 7 seven)
    test.assert (status function) "$result" "$expected"
end

test.MM.items
test.MM.lastNumKey
test.MM.indexesOf
test.MM.itemsByIndexes
test.MM.itemsByKeys
test.MM.keysByItems
test.MM.remainingSet
test.MM.remainingIndexesOf
test.MM.remainingItems
test.MM.setEntries
test.MM.setPairs
