#!/vendor/bin/sh

# run_ss_status.sh -- Gets current secure storage status

STATUSCMD="/vendor/bin/ss_status"
LOGDIR=$1

INIT_SLEEP=5
LOOP_SLEEP=1
LIMIT=10
COUNT=1
DONE=false
LOGDONE="$LOGDIR/log-ss.done"
LOGFILE="$LOGDIR/log-ss.tmp"
DATE=`/vendor/bin/date`

########

[ -s "$LOGDONE" ] && {
    # No need to fetch the status more than once
    echo "[ sstatus done ]"
    exit 0
}

umask 0077

sleep $INIT_SLEEP

[ -d "$LOGDIR" ] || /vendor/bin/mkdir $LOGDIR

echo >> $LOGFILE
echo "SS(start) [ $DATE ]" >> $LOGFILE

# Save the status of storage subsys.
# Loop in case the connection is not set up yet.
#
while [ $COUNT -le $LIMIT ] ; do
    echo >> $LOGFILE
    echo "SS(check $COUNT)" >> $LOGFILE
    $STATUSCMD 1 >> $LOGFILE 2>&1
    status=$?

    [ $status -eq 0 ] && {
	echo "SS(check $COUNT) [ $DATE ] status logged" >> $LOGFILE
	DONE=true
	break
    }

    echo "SS(check $COUNT) [ $DATE ] result: $status" >> $LOGFILE
    sleep $LOOP_SLEEP
    COUNT=`expr $COUNT + 1`
done

$DONE && {
    # Save the ss status logfile
    /vendor/bin/mv $LOGFILE $LOGDONE
    echo "[ sstatus saved $DATE ]"
    exit 0
}

echo "SS($COUNT) exceeded limit $LIMIT" >> $LOGFILE
echo "[ sstatus check limit exceeded ]"

exit 1
