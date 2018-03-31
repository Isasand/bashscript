help(){
        printf "Read a value or change it's state at weatherstation.\nFor reading a value input 'read {value}'\nFor changing a value input 'change {value}'\n\n"
}

exit(){
running=false
}

change_state(){
randomtemp=`shuf -i 19-28 -n 1`
wnaomdhum=`shuf -i 19-28 -n 1`
randomlights=1
randomkwh=50
logtype='man'
DATE=`date '+%Y-%m-&d %H:%M:%S'`
echo "input value: "
read input
case "$2" in
'temp'*)
randomtemp=$input;;
'hum'*)
randomhum=$input;;
'lights')
randomlights=$input;;
esac

txt='<?xml version = "1.0" encoding = "UTF-8" standalone = "yes"?><weatherstationreport><hum>'"$randomhum"'</hum><kwh>'"$randomkwh"'</kwh><lights>'"$randomlights"'</lights><logType>man</logType><temp>'"$randomtemp"'</temp><timeStamp>$DATE</timeStamp></weatherstationreport>'


curl -H 'Accept: application/xml' \
-H 'Content-Type: text/xml' \
-X POST -d "$txt" \
"http://192.168.0.131:8080/isasRestTest/rest/WeatherStation/update"
printf"\n"
}

read_report(){
curl http://192.168.0.131:8080/isasRestTest/rest/WeatherStation/reports/latest
printf "\n\n"
}

read_value(){
echo  "$2:"
curl http://192.168.0.131:8080/isasRestTest/rest/WeatherStation/$2
printf "\n\n"
}

running=true
echo "input a command for reading a value or changing a state. Input 'help' for instructions."
while [ $running ]; do
read input
case "$input" in
'help')
help;;
'change'*)
change_state $input;;
'read'*)
read_value $input;;
'exit')
exit;;
'report')
read_report;;
esac
done
