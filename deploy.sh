#!/bin/bash
start=`date +%s`

HOST="deploy@api.rdio-sync.com"
REPO="https://github.com/royvandewater/rdio-sync-client"
APP_DIR=/home/deploy/apps/rdio-sync-client
LOG_DIR=$APP_DIR/log
CURRENT_DIR=$APP_DIR/current
DESTINATION_DIR=$APP_DIR/releases/`date +%Y-%m-%d-%H-%M-%S`
NPM_BIN="node_modules/.bin"

function locally_do(){
  COMMAND=$@
  $COMMAND
  if [ $? -ne 0 ]; then
      echo "Failed to run: '$COMMAND'"
      exit 1
  fi
}

function over_ssh_do(){
  COMMAND=$1
  IGNORE_FAILURE=0
  if [ "$2" == "ignore_failure" ]; then
    IGNORE_FAILURE=1
  fi

  ssh $HOST "$COMMAND"
  if [ $? -ne 0 ] && [ $IGNORE_FAILURE -eq 0 ]; then
      echo "Failed to run: '$COMMAND'"
      exit 1
  fi
}

function rsync_project(){
  rsync -a -v --exclude=node_modules --exclude=.git -e "ssh" . $HOST:$DESTINATION_DIR
  if [ $? -ne 0 ]; then
      exit 1
  fi
}

function restart_forever(){
  over_ssh_do "forever ${1} \
    -l $LOG_DIR/rdio-sync-api.log \
    --append \
    -p $APP_DIR/forever \
    -c 'npm start' \
    $CURRENT_DIR" ${2}
}

function deploy(){
  # Standard Deploy
  echo "creating directories"
  over_ssh_do "mkdir -p $APP_DIR/releases $APP_DIR/log $APP_DIR/forever"

  echo "cloning git"
  over_ssh_do "git clone --depth=1 $REPO $DESTINATION_DIR"

  echo "npm install"
  over_ssh_do "cd $DESTINATION_DIR && npm install --production"

  echo "remote gulp"
  over_ssh_do "cd $DESTINATION_DIR && gulp"

  echo "linking current"
  over_ssh_do "ln -nsf $DESTINATION_DIR $CURRENT_DIR"

  echo "Restarting Forever"
  restart_forever stop ignore_failure
  restart_forever start

  end=`date +%s`
  runtime=$((end-start))
  echo "Deployed in ${runtime} seconds"
}

function restart(){
  restart_forever stop ignore_failure
  restart_forever start
}

function rollback(){
  echo "Rollback"
  echo "Pointing current to last deploy"
  LATEST_DEPLOY=$(over_ssh_do "ls -t $APP_DIR/releases | head -n 1")
  PREVIOUS_DEPLOY=$(over_ssh_do "ls -t $APP_DIR/releases | head -n 2 | tail -n 1")
  over_ssh_do "ln -nsf $APP_DIR/releases/$PREVIOUS_DEPLOY $CURRENT_DIR"
  echo "Restarting forever"
  restart_forever stop ignore_failure # ignore failure
  restart_forever start
  echo "Moving bad release to /tmp/$LATEST_DEPLOY on remote server"
  over_ssh_do "mv $APP_DIR/releases/$LATEST_DEPLOY /tmp/$LATEST_DEPLOY"
  echo "Rolled back to: $PREVIOUS_DEPLOY"
}

# Rollback

if [ "$1" == "restart" ]; then
  restart
  exit 0
fi

if [ "$1" == "rollback" ]; then
  rollback
  exit 0
fi

deploy
