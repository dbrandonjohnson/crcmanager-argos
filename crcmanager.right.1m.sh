#!/usr/bin/env bash

CRC_STATUS=$(crc status | awk 'NR==2{print $2}')
CRC_OUTPUT=$(crc status)
CRC_IP=$(crc ip)
CRC_OCADMIN=$(crc console --credentials | awk -F"'" 'NR==2{ print $2 }')
CRC_OCDEV=$(crc console --credentials | awk -F"'" 'NR==1{ print $2 }')
CRC_CREDSADMIN=$(crc console --credentials | awk 'NR==2{print $12}')
CRC_CREDSDEV=$(crc console --credentials | awk 'NR==1{print $13}')
CRC_CLUSTERMON=$(crc config get enable-cluster-monitoring | awk '{print $3}')
CRC_EXPFEATURES=$(crc config get enable-experimental-features | awk '{print $3}')

if [ "$CRC_STATUS" == Running ]; then
  echo " :o: CRC --- :white_check_mark: $CRC_STATUS | refresh=true"
elif [ "$CRC_STATUS" == Stopped ]; then
  echo " :o: CRC --- :red_circle: $CRC_STATUS | refresh=true"
elif [ "$CRC_STATUS" == Starting ]; then
  echo "  :o: CRC ---  :large_blue_circle: $CRC_STATUS | refresh=true"
elif [ "$CRC_STATUS" == Unreachable ]; then
  echo "  :o: CRC --- :bangbang: | refresh=true"
else
  echo " :o: CRC"
fi

echo "---"

echo "  :computer:		Console | bash='crc console' terminal=false"

echo "---"

echo " :white_check_mark:		Start CRC | bash='crc start' terminal=true"
echo " :red_circle:		Stop CRC | bash='crc stop' terminal=false"
echo " :x:		Delete CRC | bash='crc delete -f' terminal=false"
echo " :zap:		Full Delete CRC | bash='crc delete --clear-cache -f' terminal=false"
echo " :wrench:		Setup CRC | bash='crc setup' terminal=true"
echo " :nut_and_bolt:		Setup EX CRC | bash='crc setup --enable-experimental-features' terminal=true"

echo "---"

if [ "$CRC_CLUSTERMON" == true ]; then
  echo "Cluster Monitoring Enabled"
  echo " :no_entry:		Disable Cluster Monitoring | bash='crc config set enable-cluster-monitoring false' terminal=false refresh=true"
else
  echo " :heavy_check_mark:		Enable Cluster Monitoring | bash='crc config set enable-cluster-monitoring true' terminal=false refesh=true"
fi

echo "---"

if [ "$CRC_EXPFEATURES" == true ]; then
  echo "Cluster Experimental Features Enabled"
  echo " :no_entry:		Disable Cluster Experimental Features | bash='crc config set enable-experimental-features false' terminal=false refresh=true"
else
  echo " :heavy_check_mark:		Enable Cluster Experimental Features | bash='crc config set enable-experimental-features true' terminal=false refesh=true"
fi
echo "---"

if [ "$CRC_STATUS" == Running ]; then
  echo "$CRC_OUTPUT"
  echo "---"
  echo " :large_blue_diamond:		Set admin OC | bash='~/.crc/bin/oc/"$CRC_OCADMIN"' terminal=true"
  echo " :large_orange_diamond:		set developer OC | bash='~/.crc/bin/oc/"$CRC_OCDEV"' terminal=true"
  echo " :clipboard:		kubeadmin: $CRC_CREDSADMIN | bash='gpaste-client add $CRC_CREDSADMIN' terminal=false"
  echo " :clipboard:		developer: $CRC_CREDSDEV | bash='gpaste-client add $CRC_CREDSDEV' terminal=false"
elif [ "$CRC_STATUS" == Stopped ]; then
  echo "$CRC_STATUS"
elif [ "$CRC_STATUS" == Starting ]; then
  echo "$CRC_STATUS"
elif [ "$CRC_STATUS" == Unreachable ]; then
  echo "$CRC_STATUS"
else
  echo "CRC is likely not setup or the VM image has been deleted"
fi


