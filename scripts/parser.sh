#!/bin/bash

# VARS
OUTPUT=../tmp/ansible_facts.json
OUTPUT_TMP=../tmp/output_tmp.txt
OUTPUT_DEF=../output.txt
LOG=../log.txt
SW=("httpd" "tomcat" "wildfly" "docker" "postgresql.x86_64" "mysql" "mongodb")
SW_FS=("CYBGRDROGRW"1)
CYBERARK_USR=
#CHECK=$(dpkg -l | awk '{print $1}' | grep x86_64 |egrep -i )
YUM=/usr/bin/yum
AWK=/usr/bin/awk
EGREP=/usr/bin/egrep

# CHECK
[ ! -e $OUTPUT ] || echo "manca il file $OUTPUT" >> $LOG ; exit 1

# PARSING
echo -e "inizio il check";
for PIECE_OF_SW in "${SW[@]}";
    do
        if [ -e ${SW[$PIECE_OF_SW]}]; then
                local PROG=$($YUM list installed | $AWK '{print $1}' | $EGREP x86_64 |$EGREP -i ${SW[$PIECE_OF_SW]})
                echo -e $PROG >> $OUTPUT_TMP
                echo -e "trovato $PROG"
            else
                echo -e "NON trovato $PROG"
        fi;
    done

tr , '\n' < $OUTPUT | sed 's/"//g' | tee $OUTPUT_TMP
echo -e "creato $OUTPUT_TMP"
#rpm -qi basesystem | grep "Install Date" |awk '{print $1,$2,$6, $5, $4}'| sed 's/Install Date/Install_Date/g' >> $OUTPUT_TMP

# LAST FORMATTING
grep -i addr $OUTPUT_TMP | grep ipv4: | awk '{print $1, $3}' >> $OUTPUT_DEF


