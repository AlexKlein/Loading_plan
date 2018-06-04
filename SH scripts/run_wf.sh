export INFA_HOME=/informatica/pc9
export SHLIB_PATH=$INFA_HOME/server/bin
export LD_LIBRARY_PATH=$INFA_HOME/server/bin:$LD_LIBRARY_PATH
export PATH=$PATH:$INFA_HOME/server/bin

pmcmd startworkflow -d $1 -sv $2 -u $3  -p $4 -f $5 $6