#!/bin/bash

for para  in `echo ${PARAS} | sed 's/||/ /g'`
do 
	echo $para 
    ar=(${para//@/ })
	echo ${ar[0]}
	echo ${ar[1]}
    jspath=`ls /app/dist/js/*.*.js`
	sed -i "s?${ar[0]}?${ar[1]}?g" ${jspath}
done
