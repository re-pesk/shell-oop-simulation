# There are these types of items:
# * element - original unit of list: 
#       - simple value which can be accessed by numeric key which depends from order in associative array
#       - pair of key and value separated by "=" which can be accessed by key;
# * entry - pair of key and value, separated by "=";
# * value - part of entry to the right of separator;
# * key - part of entry to the left of separator.

# Functions:
# [x] items
# [x] lastNumKey
# [x] indexOf
# [x] itemsByIndexes
# [x] itemsByItems
# [x] remainingSet
# [x] remainingIndexesOf
# [x] remainingItems
# [x] setEntries
# [X] setPairs

# Function: MM.items returns all items from associative array
# Arguments: --output-type=<element|entry|value|key> --aa-name=<name of associative array>
function MM.items --no-scope-shadowing
    argparse --ignore-unknown 'output-type=' 'aa-name=' 'last-no-key=?' -- $argv
    set --local n 1
    if [ -n "$_flag_last_no_key" ]
        set n (math $_flag_last_no_key + 1)
    end
    for entry in $$_flag_aa_name
        string match -rgq '^(?:(?<key>(?:[^=]|\\\\=)+)=)?(?<value>.+)$' -- $entry
        switch $_flag_output_type
        case element
            if [ -z "$key" ]
            or string match -rq '^\d+$' -- $key
                echo "$value"
            else
                echo "$key=$value"
            end
        case entry
            if [ -z "$key" ]
            or string match -rq '^\d+$' -- $key
                echo "$n=$value"
                set n (math $n + 1)
            else
                echo "$key=$value"
            end
        case value
            echo $value
        case key
            if [ -z "$key" ]
            or string match -rq '^\d+$' -- $key
                echo "$n"
                set n (math $n + 1)
            else
                echo "$key"
            end
        case '*'
            echo "$key=$value"
        end
    end
end

# Function: MM.lastNumKey returns all indexes of items in associative array
# Arguments: --aa-name=<name of associative array>
function MM.lastNumKey --no-scope-shadowing
    set --local keys (MM.items --output-type=key $argv)
    set --local lastNumKey (string match -r '^\d+$' -- $keys)[-1]
    if [ -z "$lastNumKey" ]
        echo 0
    else
        echo $lastNumKey
    end
end

# Function: MM.indexesOf returns all indexes of items in associative array
# Arguments: --input-type=<element|entry|value|key> 
#            --aa-name=<name of associative array>  <item1> <item2> ... <itemN>
function MM.indexesOf --no-scope-shadowing
    argparse --ignore-unknown 'input-type=' 'aa-name=' -- $argv
    set --local itemList (MM.items --output-type=$_flag_input_type --aa-name=$_flag_aa_name)
    for arg in $argv
        contains -i -- $arg $itemList
    end
end

# Function: MM.itemsByIndexes returns items from associative array by its' indexes
# Arguments: --output-type=<element|entry|value|key> --aa-name=<name of associative array> <index1> <index2> ... <indexN>
function MM.itemsByIndexes --no-scope-shadowing
    argparse --ignore-unknown 'output-type=' 'aa-name=' -- $argv
    set --local itemList (MM.items --output-type=$_flag_output_type --aa-name=$_flag_aa_name)
    echo $itemList["$argv"]
end

# Function: MM.itemsByItems returns items from associative array corresponding to given items
# Arguments: --input-type=<element|entry|value|key> --output-type=<element|entry|value|key> 
#            --aa-name=<name of associative array> <index1> <index2> ... <indexN>
function MM.itemsByItems --no-scope-shadowing
    argparse --ignore-unknown 'output-type=' 'aa-name=' -- $argv
    set --local indexList (MM.indexesOf --aa-name=$_flag_aa_name $argv)
    MM.itemsByIndexes --output-type=$_flag_ouput_type --aa-name=$_flag_aa_name $indexList
end

# Function: MM.remainingSet returns all indexes of associative array that are not equal to any index given in positional argument
# Arguments: --aa-name=<name of associative array> <index1> <index2> ... <indexN>
function MM.remainingSet --no-scope-shadowing
    argparse --ignore-unknown 'aa-name=' -- $argv
    [ -z "$(string match -rv '^\d+$' $argv)" ]
    or echo "Error! 'sublist' contains non-numeric member!" >&2
    string match -rv -- "^(?:$(string join -- '|' $argv))\$" (seq 1 (count $$_flag_aa_name))
end

# Function: MM.remainingIndexesOf returns all indexes of items in associative array that are not any given item
# Arguments: --input-type=<element|entry|value|key> --aa-name=<name of associative array> <item1> <item2> ... <itemN>
function MM.remainingIndexesOf --no-scope-shadowing
    set --local indexList (MM.indexesOf $argv)
    argparse --ignore-unknown 'aa-name=' -- $argv
    MM.remainingSet --aa-name=$_flag_aa_name $indexList
end

# Function: MM.remainingItems returns items from associative array complementing to given items 
#   (without given items).
# Arguments: --input-type=<element|entry|value|key> --output-type=<element|entry|value|key>
#            --aa-name=<name of associative array> <item1> <item2> ... <itemN>
function MM.remainingItems --no-scope-shadowing
    argparse --ignore-unknown 'output-type=' 'aa-name=' -- $argv

    set --local complementIndexList (MM.remainingIndexesOf --aa-name=$_flag_aa_name $argv) 
    MM.itemsByIndexes --output-type=$_flag_output_type --aa-name=$_flag_aa_name $complementIndexList
end

# Function: MM.setEntries adds entries to associative array and returns its items
# Arguments: --output-type=<element|entry|value|key>
#            --aa-name=<name of associative array> <entry1> <entry2> ... <entryN>
function MM.setEntries --no-scope-shadowing
    
    # get name of old AA (associative array) and other parameters
    argparse --ignore-unknown 'output-type=?' 'aa-name=' -- $argv
    
    # default value of ouput-type is "entry"
    if [ -z "$_flag_ouput_type" ]
        set $_flag_ouput_type entry
    end
    
    # set args to local array
    set --local args $argv

    # get keys of args to local array
    set --local newKeys (string match -rg '^(?:(?<key>(?:[^=]|\\\\=)+)=)?.+$' -- $args)

    # get keys of old AA
    set --local oldKeys (MM.items --output-type=key --aa-name=$_flag_aa_name)

    # result entries
    set --local newEntries

    for oldIndex in (seq 1 (count $$_flag_aa_name))
        set --local newIndex (contains -i -- $oldKeys[$oldIndex] $newKeys)
        if [ -z "$newIndex" ]
            set --append newEntries (set --query $_flag_aa_name ; and eval echo "\$$_flag_aa_name"[$oldIndex])
        else
            set --append newEntries $args[$newIndex]
        end
    end

    # get indexes of keys in newKeys that are not in oldKeys 
    set --local complementNewIndexes (MM.remainingIndexesOf --input-type=value --aa-name=newKeys $oldKeys)
    for index in $complementNewIndexes
        set --append newEntries $args[$index]
    end

    # return items in guiven output type
    MM.items --output-type=$_flag_output_type --aa-name=newEntries
end

# Function: MM.setPairs adds key-value pairs to associative array and returns its items
# Arguments: --output-type=<element|entry|value|key>
#            --aa-name=<name of associative array> <key1> <value1> <key2> <value2> ... <keyN> <valueN>
function MM.setPairs --no-scope-shadowing
    argparse --ignore-unknown 'output-type=?' 'aa-name=' -- $argv
    MM.setEntries --output-type=$_flag_output_type --aa-name=$_flag_aa_name (printf '%s=%s\n' $argv)
end
