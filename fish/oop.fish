#! /usr/bin/env -S fish

# set fish_trace on

function processArgs
  argparse -i 'object-name=?' 'field-list=?' -- $argv
  set -l object_name "$_flag_object_name"
  set -l field_list (string split " " $_flag_field_list)
  set -l entry_args (string match -ra '^(?:[^:]|\\:)+:=.+$' $argv)
  set -l argv (string match -rav '^(?:[^:]|\\:)+:=.+$' $argv)
  set -l entries ()
  for key in $field_list
    set -l matches (string match -ra '^'$key':=.+$' $entry_args)
    if test -n "$matches[-1]"
      set -a entries "$object_name.$matches[-1]"
    else
      set -a entries "$object_name.$key:=$argv[1]"
      set -e argv[1]
    end
  end
  string match -ra '^.*$' $entries
  # printf '%s\n' $entries
end

# Class maker: class (arguments: class_name, ...field_names)
function class -a class_name
  set -l field_list $argv[2..]
  set -l class_data_varname $class_name"_class_data"
  set -g $class_data_varname ()

  # Class method: data
  function $class_name.data -V class_data_varname -a object_name
    if test -n "$object_name"
      string match -ar -- '^'$object_name.'(?:[^:]|\\:)+:=.+$' $$class_data_varname
      return
    end
    string match -ar -- '^.+$' $$class_data_varname
  end

  # Class method: fieldList
  function $class_name.fieldList -V field_list
    printf '%s\n' $field_list 
  end

  # Class method: getVal (arguments: object_name.key | object_name key)
  function $class_name.getVal -V class_data_varname
    set -l object_name_key (string join '.' $argv)
    string match -agr -- '^'$object_name_key':=(?<value>.+)$' $$class_data_varname
  end

  # Class method: getEntry (arguments: object_name.key | object_name key)
  function $class_name.getEntry -V class_data_varname
    set -l object_name_key (string join '.' $argv)
    string match -ar -- '^'$object_name_key':=.+$' $$class_data_varname
  end

  # Class method: sayHello (arguments: object_name)
  function $class_name.sayHello -V class_name -a object_name
    echo "Hello, my name is "($class_name.getVal $object_name name)" and I am "($class_name.getVal $object_name age)" years old."
  end

  # Class method: setVal (arguments: object_name.key value | object_name key value)
  function $class_name.setVal -V class_data_varname -V class_name
    set -l arg_count (count $argv)
    if ! contains "$arg_count" (seq 2 3)
      echo "Error: wrong number of arguments! It must be 2 or 3." >&2
      return 1
    end
    set -l value "$argv[-1]"
    set -l object_name_key "$argv[1]"
    test $arg_count -gt 2 && set object_name_key "$argv[1].$argv[2]"
    set -l old_value ($class_name.getVal $object_name_key)
    if test -n "$old_value"
      set -g "$class_data_varname" (string replace -ar '(?<=^'$object_name_key':=)'$old_value'(?=$)' $value $$class_data_varname)
      return 
    end
    set -a "$class_data_varname" "$object_name_key:=$value"
  end

  # Class method: toString (arguments: object_name)
  function $class_name.toString -V class_name -a object_name
    if test -z "$object_name"
      echo "Error: missing object name" >&2
      return 1
    end
    printf "%s %s " "$class_name.new" "$object_name" (string match -agr '^'$object_name.'((?:[^:]|\\:):=.+)$' ($class_name.data $object_name)) \n
  end

  # Class method: delete (arguments: object_name)
  function $class_name.delete -V class_name -V class_data_varname -a object_name
    if test -z "$object_name"
      echo "Error: missing object name" >&2
      return 1
    end
    # string match -arv '^'$object_name.'(?:[^:]|\\:)+:=.+$' $$class_data_varname
    set $class_data_varname (string match -arv '^'$object_name.'(?:[^:]|\\:)+:=.+$' $$class_data_varname)
    # set funcs (functions -n | string match -ar '^person3.[^ ]+$')
    for fun in (functions -n | string match -ar '^person3.[^ ]+$')
      functions -e "$fun"
    end
  end


  # Class method - instance constructor: <class_name> (arguments: object_name:="names list" ) 
  function $class_name.new -V class_name -V class_data_varname -V field_list -a object_name
    set -a "$class_data_varname" (processArgs --object-name=$object_name --field-list="$field_list" $argv[2..])

    # Instance method: alias of class method
    alias $object_name.getVal "$class_name.getVal $object_name"

    # Instance method: alias of class method
    alias $object_name.getEntry "$class_name.getEntry $object_name"

    # Instance method: alias of class method
    alias $object_name.sayHello "$class_name.sayHello $object_name"
  
    # Instance method: alias of class method
    alias $object_name.setVal "$class_name.setVal $object_name"

    # Instance method: alias of class method
    alias $object_name.data "$class_name.data $object_name"

    # Instance method: alias of class method
    alias $object_name.toString "$class_name.toString $object_name"

    # Instance method: alias of class method
    alias $object_name.delete "$class_name.delete $object_name"
  end

end
