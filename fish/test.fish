#! /usr/bin/env -S fish

. ./oop.fish

echo

function classTestsNew

  class Person name age
  echo "Person.fieldList =>" (Person.fieldList)
  echo Person.new person1 Alice 28 \n
  Person.new person1 Alice 28
  
  echo "Person.getVal person1.age =>" (Person.getVal person1.age)
  echo "Person.setVal person1"; Person.setVal person1
  echo "Person.setVal person1.age 35"; Person.setVal person1.age 35 
  echo "Person.getVal person1.age =>" (Person.getVal person1.age)
  echo "Person.setVal person1 age 40"; Person.setVal person1 age 40
  echo "Person.getVal person1.age =>" (Person.getVal person1.age)

end

function simpleTests

set input abc 'ab c' "ab c" 'a b"c' "a b'c" "a b\"c" abc=a 'ab c'=a "ab c"=a 'a b"c'=a "a b'c"=a "a b\"c"=a a=abc a='ab c' a="ab c" a='a b"c' a="a b'c" a="a b\"c"
echo "input =>" "("$input")"

set entries (string match -rag '\(([^=\(\)]+=[^\(\)]+)\)' "("$input")")
echo "entries =>" "("$entries")"
# string match -ran '\(([^=\(\)]+=[^\(\)]+)\)' "$input"
set simple (string match -rag '\(([^\)]+)\)' (string match -rav '\([^=]+=[^\)]+\)' $input))
echo "simple =>" "("$simple")"

set args hair:=blond White 182cm "'hair':=\"blond\""
echo "args =>" "("$args")"

set entries (string match -rag '\(([^=\(\)]+=[^\(\)]+)\)' "("$args")")
echo "entries =>" "("$entries")"
set simple (string match -rag '\(([^\)]+)\)' (string match -rav '\([^=]+=[^\)]+\)' "("$args")"))
echo "simple =>" "("$simple")" \n

echo "------"\n"mytest"\n"------"\n
function mytest
  processArgs $argv
end

echo mytest --object-name=obj --field-list="name surname age height hair:color" name:=Alice age:=28 hair:color:=blond surname:=Khan 182cm black hair:color:="dark gray"
echo "result =>" "("(mytest --object-name=obj --field-list="name surname age height hair:color" name:=Alice age:=28 hair:color:=blond surname:=Khan 182cm black hair:color:="dark gray")")"
# echo "result => " $result

end

function classTests

  class Person name age
  echo "Person.fieldList =>" (Person.fieldList)
  echo "Person.new person1 Alice 28"; Person.new person1 Alice 28
  echo "person1.data =>" (person1.data)
  echo "count (person1.data) =>" (count (person1.data))
  echo "Person.data =>" (Person.data)
  echo "count (Person.data) =>" (count (Person.data)) \n
  # return

  echo "person1.getVal name =>" (person1.getVal name)
  echo "person1.getVal surname =>" (person1.getVal surname)
  echo "person1.getEntry name =>" (person1.getEntry name)
  echo "person1.setVal name John"; person1.setVal name John
  echo "person1.getVal name =>" (person1.getVal name)
  echo "person1.getEntry name =>" (person1.getEntry name)
  echo "Person.getVal person1 name =>" (Person.getVal person1 name)
  echo "Person.getVal person1.name =>" (Person.getVal person1.name)
  echo "Person.data =>" (Person.data) \n
  
  echo "person1.getVal age =>" (person1.getVal age)
  echo "person1.setVal age 29"; person1.setVal age 29
  echo "person1.getVal age =>" (person1.getVal age)
  echo "Person.data =>" (Person.data) \n

  echo "count (Person.data) =>" (count (Person.data))
  echo "count (person1.data) =>" (count (person1.data))
  echo "person1.setVal hair blond"; person1.setVal hair blond
  echo "count (person1.data) =>" (count (person1.data))
  echo "count (Person.data) =>" (count (Person.data))
  echo "Person.data =>" (Person.data) \n

  echo "Person.sayHello person1 =>" (Person.sayHello person1)
  echo "person1.sayHello =>" (person1.sayHello)
  echo "person1.data =>" (person1.data)
  echo "person1.toString =>" (person1.toString)
  echo "Person.data =>" (Person.data)
  echo "Person.toString =>" (Person.toString) \n

  echo "Person.new person2 Alice 28"; Person.new person2 Alice 28
  echo "Person.data =>" (Person.data) \n

  echo "person2.sayHello =>" (person2.sayHello)
  echo "person2.data =>" (person2.data)
  echo "person2.toString =>" (person2.toString)
  echo "Person.data =>" (Person.data) \n
  echo "Person_class_data =>" $Person_class_data \n
  # return

  echo "Person.new person3 name:=Austėja age:=30"; Person.new person3 name:=Austėja age:=30
  echo "person3.data =>" (person3.data)
  echo "Person.data =>" (Person.data)
  echo "Person.toString person3 =>" (Person.toString person3) \n

  echo "Person.data =>" (Person.data)
  # echo "Person.delete person3"; Person.delete person3
  echo "person3.delete"; person3.delete
  echo "Person.data =>" (Person.data)
  echo "functions -q person3.delete =>" (functions -q "person3.delete" && echo true || echo false)
  
end

# simpleTests
classTests
# classTestsNew
