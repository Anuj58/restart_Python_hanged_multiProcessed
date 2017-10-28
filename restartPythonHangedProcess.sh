
# Condition to check if process are active or not
# check that script run time is static or updating in last 30 min

cd '/data/analytics/ng_jobalert_newCode/ng_jobalert_newCode/Features'
# check that script output file update tim is 30 min before
threads=$(ps -ef | grep Extract | grep -v grep|grep -v sudo|wc -l)
echo threads,$threads

files=$(find features.log -mmin +20)
if [[ $? != 0 ]]; then
    echo "Command failed. thass at-least Execute the code to test"
elif [[ $files  && $threads>3 ]]; then
    echo "ExtractFeature code is not active !!! Champak Code"
    cd '/data/analytics/ng_jobalert_newCode/ng_jobalert_newCode/Scripts'
    /usr/local/ActivePython-2.7/bin/python2.7   /data/ng_jobalert_newCode/ng_jobalert_newCode/Scripts/run_mailers2.py 'Killing all process as they are inactive' 'Killing all process as they are inactive'
    # search code is inactive then kill all the process
    ps -ef | grep Extract | grep -v grep|grep -v sudo | awk '{print $2}' |  xargs kill
    /usr/local/ActivePython-2.7/bin/python2.7   /data/ng_jobalert_newCode/ng_jobalert_newCode/Scripts/run_mailers2.py 'Completed Killing all process as they are inactive' 'Completed Killing all process as they are inactive'
    cd '/data/analytics/ng_jobalert_newCode/ng_jobalert_newCode/Features'

    echo 'Extracting Features for training'
    cd '/data/ng_jobalert_newCode/ng_jobalert_newCode/Features'
    /usr/local/ActivePython-2.7/bin/python2.7   /data/ng_jobalert_newCode/ng_jobalert_newCode/Scripts/run_mailers.py 'REStarting Features for training 120 days ' 'REStarting Features for training 120 days '
    /usr/local/ActivePython-2.7/bin/python2.7   /data/ng_jobalert_newCode/ng_jobalert_newCode/Features/ExtractFeaturesAndRecommend_v50.py >> features.log 2>> features.err
    if [ $? -eq 0 ];then
       echo "Script successful"
    else
       echo 'Sending ERROR Mail'
       /usr/local/ActivePython-2.7/bin/python2.7   /data/ng_jobalert_newCode/ng_jobalert_newCode/Scripts/run_mailers2.py '[NG JA] REExecution |ERRORMAILER: Cannot Extract Feature and Send mailer   ' '[NG JA] Cannot Extract Feature and Send mailer----failed'
    fi
    /usr/local/ActivePython-2.7/bin/python2.7   /data/ng_jobalert_newCode/ng_jobalert_newCode/Scripts/run_mailers.py 'REStarting Features for training 120 days ....completed' 'REStarting Features for training 120 days ....completed'
    echo 'Extracting Features for training....completed'
else
   echo "ExtractFeature code is active or already executed Thanks !!!"
fi

