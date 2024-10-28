#!/bin/bash

#this array for commands i selected 
commands=(ls touch mv rm cat head tail more less wc rev which factor seq uniq logname pwd who date ps)

generate() {

#Generate a Test file
for i in {1..15}; do echo "Line $i" >> TEST_.txt; done

# check the second parameter if it's supported or not
if [ "$#" -eq 2 ];then
flag=1
for command in "${commands[@]}"; do
       if [ "$command" = "$2" ];then
         flag=0
         break 
       fi
done
if [ $flag -eq 1 ] ; then echo "This command is not supported" ; exit 2 ;fi
fi


#****************************************************************

# creating the files for the choosed commands
for command in "${commands[@]}"; do
    if [ "$#" -eq 2 ];then
       if [ "$command" != "$2" ];then
         continue
       fi
    fi

    if [ -e "$command.txt" ]; then
    echo "The files are already generated !"
    break
    fi
    touch "$command.txt"

    touch desc
    man "$command" | awk '/^DESCRIPTION/,/^$/' | sed '/^$/d' > desc
    grep -v "DESCRIPTION" desc | sed 's/^ //; s/ \+/ /g' > description
    rm desc 
    
    
    
    if [ "$command" = "which" ] || [ "$command" = "pwd" ] 
    then 
    echo "Bash version :" $BASH_VERSION > version
    else
    "$command" --version | head -n 1 | sed 's/.* //' > version
    fi

    
    #printf "Description\t$(cat description)\nVersion\t$version\n" | column -W 2 -s $'\t\t' -tt >> "$command.txt"
    printf "Description          " >> "$command.txt"
    sed '1!s/^/                     /' description > des
    cat des >> "$command.txt"     
    rm des description
    printf "%s" "--------------------------------------------------------------------------------------" >> "$command.txt"
    
    printf "\nVersion               " >> "$command.txt"
    cat version >> "$command.txt"
    printf "%s" "--------------------------------------------------------------------------------------" >> "$command.txt"
    rm version
    
    example=""
    
    if [ "$command" = "ls" ];then
    echo ">>$ $command" >> example
    $command >> example
    
    elif [ "$command" = "touch" ];then
    echo ">>$ ls" >> example
    ls >> example
    echo ">>$ touch newfile.txt" >> example
    touch newfile.txt
    echo ">>$ ls" >> example
    ls >> example
    rm newfile.txt

    elif [ "$command" = "rm" ];then
    echo ">>$ touch test_rm.txt" >> example
    touch test_rm.txt
    echo ">>$ ls" >> example
    ls >> example
    echo ">>$ rm test_rm.txt" >> example
    rm test_rm.txt
    echo ">>$ ls" >> example
    ls >> example

    elif [ "$command" = "cat" ] || [ "$command" = "head" ] || [ "$command" = "tail" ] \
    || [ "$command" = "more" ] || [ "$command" = "less" ] || [ "$command" = "wc" ]\
    || [ "$command" = "rev" ]
    then
    echo ">>$ $command TEST_.txt" >> example
    $command TEST_.txt >> example

    elif [ "$command" = "mv" ];then
    echo ">>$ touch oldName.txt" >> example
    touch oldName.txt >> example
    echo ">>$ ls" >> example
    ls >> example
    echo ">>$ mv oldName.txt newName.txt" >> example
    mv oldName.txt newName.txt >> example
    echo ">>$ ls" >> example
    ls >> example
    rm newName.txt

    elif [ "$command" = "which" ];then
    echo ">>$ which bash" >> example
    which bash >> example
    
    elif [ "$command" = "factor" ];then
    echo ">>$ factor 250" >> example
    factor 250 >> example
    
    elif [ "$command" = "seq" ];then
    echo ">>$ seq 0 5" >> example
    seq 0 5 >> example

    elif [ "$command" = "uniq" ];then
    echo ">>$ touch before_uniq.txt" >> example
    touch before_uniq.txt 
    echo ">>$ echo -e \"1\\n2\\n2\\n2\\n3\\n3\\n4\\n5\\n5\\n5\" >> before_uniq.txt" >> example
    echo -e "1\n2\n2\n2\n3\n3\n4\n5\n5\n5" >> before_uniq.txt
    echo ">>$ cat before_uniq.txt" >> example
    cat before_uniq.txt >> example
    echo ">>$ uniq before_uniq.txt after_uniq.txt" >> example
    uniq before_uniq.txt after_uniq.txt
    echo ">>$ cat after_uniq.txt" >> example
    cat after_uniq.txt >> example
    rm before_uniq.txt
    rm after_uniq.txt
 
    else 
    echo ">>$ $command " >> example
    $command >> example
    fi

   printf "\nExample               " >> "$command.txt"
   sed '1!s/^/                      /' example > examp
   cat examp >> "$command.txt"
   rm example examp 

printf "%s" "--------------------------------------------------------------------------------------" >> "$command.txt"
printf "\nRelated commands      " >> "$command.txt"
compgen -c | grep  "$command" > related
sed '1!s/^/                      /' related > rel
cat rel >> "$command.txt"
rm related rel
done
rm TEST_.txt

}
##########################################################################
##########################################################################
##########################################################################
##########################################################################

verify(){
    for i in {1..15}; do echo "Line $i" >> TEST_.txt; done
       
   if [ "$#" -eq 2 ];then
flag=1
for command in "${commands[@]}"; do
       if [ "$command" = "$2" ];then
         flag=0
         break 
       fi
done
if [ $flag -eq 1 ] ; then echo "This command is not supported" ; exit 2 ;fi
fi


#****************************************************************

# creating the files for the choosed commands
for command in "${commands[@]}"; do
    if [ "$#" -eq 2 ];then
       if [ "$command" != "$2" ];then
         continue
       fi
    fi

    if [ -e "${command}_test.txt" ]; then
    echo "The files are already generated !"
    break
    fi
    touch "${command}_test.txt"


    touch desc
    man "$command" | awk '/^DESCRIPTION/,/^$/' | sed '/^$/d' > desc
  
    grep -v "DESCRIPTION" desc | sed 's/^ //; s/ \+/ /g' > description
    rm desc 
    
    
    
    if [ "$command" = "which" ] || [ "$command" = "pwd" ] 
    then 
    echo "Bash version :" $BASH_VERSION > version
    else
    "$command" --version | head -n 1 | sed 's/.* //' > version
    fi

    
    #printf "Description\t$(cat description)\nVersion\t$version\n" | column -W 2 -s $'\t\t' -tt >> "$command.txt"
    printf "Description          " >> "${command}_test.txt"
    sed '1!s/^/                     /' description > des
    cat des >> "${command}_test.txt"     
    rm des description
    printf "%s" "--------------------------------------------------------------------------------------" >> "${command}_test.txt"
    
    printf "\nVersion               " >> "${command}_test.txt"
    cat version >> "${command}_test.txt"
    printf "%s" "--------------------------------------------------------------------------------------" >> "${command}_test.txt"
    rm version
    
    example=""
    
    if [ "$command" = "ls" ];then
    echo ">>$ $command" >> example
    $command >> example
    
    elif [ "$command" = "touch" ];then
    echo ">>$ ls" >> example
    ls >> example
    echo ">>$ touch newfile.txt" >> example
    touch newfile.txt
    echo ">>$ ls" >> example
    ls >> example
    rm newfile.txt

    elif [ "$command" = "rm" ];then
    echo ">>$ touch test_rm.txt" >> example
    touch test_rm.txt
    echo ">>$ ls" >> example
    ls >> example
    echo ">>$ rm test_rm.txt" >> example
    rm test_rm.txt
    echo ">>$ ls" >> example
    ls >> example

    elif [ "$command" = "cat" ] || [ "$command" = "head" ] || [ "$command" = "tail" ] \
    || [ "$command" = "more" ] || [ "$command" = "less" ] || [ "$command" = "wc" ]\
    || [ "$command" = "rev" ]
    then
    echo ">>$ $command TEST_.txt" >> example
    $command TEST_.txt >> example

    elif [ "$command" = "mv" ];then
    echo ">>$ touch oldName.txt" >> example
    touch oldName.txt >> example
    echo ">>$ ls" >> example
    ls >> example
    echo ">>$ mv oldName.txt newName.txt" >> example
    mv oldName.txt newName.txt >> example
    echo ">>$ ls" >> example
    ls >> example
    rm newName.txt

    elif [ "$command" = "which" ];then
    echo ">>$ which bash" >> example
    which bash >> example
    
    elif [ "$command" = "factor" ];then
    echo ">>$ factor 250" >> example
    factor 250 >> example
    
    elif [ "$command" = "seq" ];then
    echo ">>$ seq 0 5" >> example
    seq 0 5 >> example

    elif [ "$command" = "uniq" ];then
    echo ">>$ touch before_uniq.txt" >> example
    touch before_uniq.txt 
    echo ">>$ echo -e \"1\\n2\\n2\\n2\\n3\\n3\\n4\\n5\\n5\\n5\" >> before_uniq.txt" >> example
    echo -e "1\n2\n2\n2\n3\n3\n4\n5\n5\n5" >> before_uniq.txt
    echo ">>$ cat before_uniq.txt" >> example
    cat before_uniq.txt >> example
    echo ">>$ uniq before_uniq.txt after_uniq.txt" >> example
    uniq before_uniq.txt after_uniq.txt
    echo ">>$ cat after_uniq.txt" >> example
    cat after_uniq.txt >> example
    rm before_uniq.txt
    rm after_uniq.txt
 
    else 
    echo ">>$ $command " >> example
    $command >> example
    fi

   printf "\nExample               " >> "${command}_test.txt"
   sed '1!s/^/                      /' example > examp
   cat examp >> "${command}_test.txt"
   rm example examp 

printf "%s" "--------------------------------------------------------------------------------------" >> "${command}_test.txt"
printf "\nRelated commands      " >> "${command}_test.txt"
compgen -c | grep  "$command" > related
sed '1!s/^/                      /' related > rel
cat rel >> "${command}_test.txt"
rm related rel 

diff "${command}_test.txt" "$command.txt" >> /dev/null
if [ "$?" -eq 0 ]; then
    if [ "$#" -eq 2 ];then 
    echo "The manual file for the command \"$command\" has Passed the verification test"
    fi
else
    echo "The manual for the command \"$command\" has Failed in the verification test"
    diff "${command}_test.txt" "$command.txt" 
fi
   rm "${command}_test.txt"

done

rm TEST_.txt

}

#########################################################################
#########################################################################
#########################################################################
#########################################################################
remove (){
for command in "${commands[@]}"; do
    rm "$command.txt"
done
}

search(){
   word="$2"
   touch res
   for command in "${commands[@]}"; do
    if grep -q "$word" "$command.txt"; then  
        echo $command >> res
    fi
   done
if [ ! -s res ]; then
    echo "The required word was not found !"
    else cat res
fi
rm res
}

suggest(){
# this two lines for accessing history from non interactive shell
HISTFILE=~/.bash_history
set -o history


recent=$(history 100)

commands=$(echo "$recent" | awk '{print $2}' | sort)

sorted=$(echo "$commands" | uniq -c | sort -n)

echo "$sorted" | head -n 5


}

# Choosing between operations 
if [ "$#" -eq 0 ];then 
echo "Please specify the operation you want (generate,verify,search,suggest,remove)"
exit 1 
elif [ "$#" -gt 2 ];then
echo "too more arguments"
elif [ "$1" = "generate" ];then
generate "$@"
elif [ "$1" = "verify" ];then
verify "$@"
elif [ "$1" = "remove" ];then
remove 
elif [ "$1" = "search" ];then
search "$@"
elif [ "$1" = "suggest" ];then
suggest
else echo "Invalid arguments ! try again ..."
fi
