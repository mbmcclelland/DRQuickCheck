#2018-06-11 MMc: Added SELinux Status, cleaned up column names.
#2017-05-23 MMc
#A quick check of vital info for a Digital Reef Cluster
#Outputs a simple CSV
#Works best with Passwordless ssh

pushd /home/auraria/
nodeIps=`su auraria -c 'psql -d auraria_mgmt -U auraria -t -c "SELECT ipaddress from mgmtrealmnode"|xargs'`

#Not really necessary since we are re-doing Review, but this is how you check if Review is enabled
#reviewEnabled=`su auraria -c 'psql -d auraria_mgmt -U auraria -t -c "SELECT reviewappenabled from mgmtrealm"|xargs'`
#if [ "$reviewEnabled" = "t" ]; then
#       echo "Review is enabled on this system"
#else
#        echo "Review NOT ENABLED"
#fi

#command List
 ipAddress   () { ssh $i ip addr show|grep \/24|sed 's/inet //;s/\/.*$//'|xargs; }
 hostNames   () { ssh $i hostname; }
 coreCount   () { ssh $i cat /proc/cpuinfo|grep cores|wc -l; }
 memTotals   () { ssh $i cat /proc/meminfo|grep MemTotal|sed 's/MemTotal://;s/kB//'|xargs; }
 dateTime    () { ssh $i date "+%Y/%m/%d_%H:%M:%S"; }
 sestat      () { ssh $i sestatus|sed --expression='s/SELinux status:[ \t]*//g'; }
 drVersion   () { ssh $i service drd status|grep 'Version: R'|sed 's/Version: //'; }
 drNodeType  () { ssh $i service drd status|grep 'Node Type:'|sed 's/Node Type://'|xargs; }
 kernelVer   () { ssh $i service drd status|grep 'Kernel:'|sed 's/Kernel://'|xargs; }
 rootFileSys () { ssh $i df -BG /|tail -1|awk '{print $1}'; }
 rootSize    () { ssh $i df -BG /|tail -1|awk '{print $2}'; }
 rootUsed    () { ssh $i df -BG /|tail -1|awk '{print $3}'; }
 rootAvail   () { ssh $i df -BG /|tail -1|awk '{print $4}'; }
 rootFree    () { ssh $i df -BG /|tail -1|awk '{print $5}'; }
 drSwapFS    () { ssh $i df -BG /opt/digitalreef|tail -1|awk '{print $1}'; }
 drSwapSize  () { ssh $i df -BG /opt/digitalreef|tail -1|awk '{print $2}'; }
 drSwapUsed  () { ssh $i df -BG /opt/digitalreef|tail -1|awk '{print $3}'; }
 drSwapAvail () { ssh $i df -BG /opt/digitalreef|tail -1|awk '{print $4}'; }
 drSwapFree  () { ssh $i df -BG /opt/digitalreef|tail -1|awk '{print $5}'; }

#Header line
echo   "IP_Address,Hostname,CPU_count,MemTotal,DateTime,SELinux,DR_Version,Node_Type,Kernel,Filesystem,Root_Size,Root_Used,Root_Avail,Root_Free%,DR_swap_Filesystem,DR_swap_Size,DR_swap_Used,DR_swap_Avail,DR_swap_Free"

for i in $nodeIps
 do
  echo "$(ipAddress),$(hostNames),$(coreCount),$(memTotals),$(dateTime),$(sestat),$(drVersion),$(drNodeType),$(kernelVer),$(rootFileSys),$(rootSize),$(rootUsed),$(rootAvail),$(rootFree),$(drSwapFS),$(drSwapSize),$(drSwapUsed),$(drSwapAvail),$(drSwapFree)"
 done
popd