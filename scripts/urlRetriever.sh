#!/bin/bash


# defining all functions that will be used in the script
function extract_links(){
    #retrieve content of url
    curl -s -f --location $url > page.html
    # regex to extract url from html file: https://unix.stackexchange.com/questions/181254/how-to-use-grep-and-cut-in-script-to-obtain-website-urls-from-an-html-file
    # then sort them, and remove duplicates, and output to a file
    # I had a doubt regarding whether we want to filter on the url, as it looked like in the command, but for me, all links are all links :)
    # other I would have added a "grep $url" before the sort command
    cat page.html | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" |  sort | uniq >> $output_file
    #clean up
    rm page.html 
}
function json_formatting(){
    # create empty array
    output={}
    # browsing line by line $output_file to parse and create json object
    while IFS= read -r line; do
        slash="/"
        # Extract domain using cut
        domain=$(cut -d '/' -f 1,3 <<< "$line")
        # Extract relative path using sed
        relat_path=$slash$(cut -d '/' -f4- <<< "$line")
        # Update JSON object using jq
        # I will not lie, finding the right way to write the jq query was not easy :)
        output=$(jq --arg r ${relat_path} --arg d ${domain} '.[$d] += [$r]' <<< $output)
    done < $output_file
    #output final json object in a file
    echo $output > output.json
    ## pretty print the result: https://stackoverflow.com/questions/352098/how-can-i-pretty-print-json-in-a-shell-script
    jq --color-output . output.json 
    #clean up
    rm output.json
}

function output_results(){
    # Treating the cases of output, stdout, json or wrong input
    if [ "$OUTPUT_TYPE" = "stdout" ]; then
        cat $output_file
    elif [ "$OUTPUT_TYPE" = "json" ]; then
        # user selected json, we'll deal with it in json_formatting function
        json_formatting
    else
        echo "wrong output type"
        print_help
    fi
    rm $output_file
}

function print_help() {
    echo "The script has a purpose to extract links and present it either in json or stdout"
    echo "which will, given any number of HTTP URLs as command line parameters, connect to each URL, extract all links from it, and depending on the “-o” option, output either: one absolute URL per line or a JSON hash where the key is the base domain, and the array is the relative path" 
    echo "usage is ./urlRetriever.sh -u <url_link> -o <stdout or json> "
    echo "example ./urlRetriever.sh -u https:/stackoverflow.com -o stdout"
}

# Entrypoint of the script, running through all arg in the while
##
output_file=output_links
while [[ $# -gt 0 ]]
    do 
    key="$1"
    case $key in
        #if arg -u is here, we will enter extract_links function
        -u|--url)
            shift
            url="$1"
            extract_links
            shift
            ;;
        #if arg -o is here, we will enter output_results function
        -o|--output)
            shift
            OUTPUT_TYPE="$1"
            output_results
            shift
            ;;
        #if arg -h is here, we will enter print_help function
        -h|--help)
            print_help
            exit
            ;;
        #Trying to catch wrong user inputs, we will enter print_help function
        *) 
            print_help
            exit 
            ;;
    esac
done

