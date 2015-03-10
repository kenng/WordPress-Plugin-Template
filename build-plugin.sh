#!/bin/bash

printf "Plugin name: "
read NAME

printf "Author name: "
read AUTHOR

printf "Destination Parent folder: "
read FOLDER

printf "Include Grunt support (y/n): "
read GRUNT

printf "Initialise new git repo (y/n): "
read NEWREPO


DEFAULT_NAME="WordPress Plugin Template"
DEFAULT_CLASS=${DEFAULT_NAME// /_}
DEFAULT_TOKEN=$( tr '[A-Z]' '[a-z]' <<< $DEFAULT_CLASS)
DEFAULT_SLUG=${DEFAULT_TOKEN//_/-}
DEFAULT_AUTHOR="Hugh Lashbrooke"

CLASS=${NAME// /_}
TOKEN=$( tr '[A-Z]' '[a-z]' <<< $CLASS)
SLUG=${TOKEN//_/-}
SLUG_DIR=$FOLDER/$SLUG


RSYNC_EXCLUDE_LIST="--exclude=.git --exclude=README.md --exclude=build-plugin.sh --exclude=changelog.txt --exclude=.swp --exclude=$DEFAULT_SLUG.php --exclude=readme.txt --exclude=lang/$DEFAULT_SLUG.pot --exclude=includes/class-$DEFAULT_SLUG.php --exclude=includes/class-$DEFAULT_SLUG-settings.php --exclude=includes/lib/class-$DEFAULT_SLUG-post-type.php --exclude=includes/lib/class-$DEFAULT_SLUG-taxonomy.php --exclude=includes/lib/class-$DEFAULT_SLUG-admin-api.php"


if [ "$GRUNT" == "n" ]; then
	#rm Gruntfile.js
	#rm package.json
  EXCLUDE_LIST="$RSYNC_EXCLUDE_LIST --exclude=Gruntfile.js --exclude=package.json"
fi


#git clone git@github.com:hlashbrooke/$DEFAULT_SLUG.git $FOLDER/$SLUG
#cp -rf ../`basename $PWD` $FOLDER/$SLUG
rsync -rtv ../`basename $PWD`/ $EXCLUDE_LIST $FOLDER/$SLUG

if [ $? != 0 ]; then
  # exit if not successful
  echo 'Exit as error encountered.'
  exit 1
fi

echo "Updating plugin files..."

sed -e "s/$DEFAULT_NAME/$NAME/g" \
    -e "s/$DEFAULT_SLUG/$SLUG/g" \
    -e "s/$DEFAULT_TOKEN/$TOKEN/g" \
    -e "s/$DEFAULT_CLASS/$CLASS/g" \
    -e "s/$DEFAULT_AUTHOR/$AUTHOR/g" \
    $DEFAULT_SLUG.php > $SLUG_DIR/$SLUG.php


sed "s/$DEFAULT_NAME/$NAME/g" readme.txt > $SLUG_DIR/readme.txt

sed -e "s/$DEFAULT_NAME/$NAME/g" \
    -e "s/$DEFAULT_CLASS/$CLASS/g" \
    -e "s/$DEFAULT_TOKEN/$TOKEN/g" \
    -e "s/$DEFAULT_SLUG/$SLUG/g" \
    -e "s/$DEFAULT_AUTHOR/$AUTHOR/g" \
    lang/$DEFAULT_SLUG.pot > $SLUG_DIR/lang/$SLUG.pot


sed -e "s/$DEFAULT_CLASS/$CLASS/g" \
    -e "s/$DEFAULT_TOKEN/$TOKEN/g" \
    -e "s/$DEFAULT_SLUG/$SLUG/g" \
    includes/class-$DEFAULT_SLUG.php > includes/class-$SLUG.php

sed -e "s/$DEFAULT_CLASS/$CLASS/g" \
    -e "s/$DEFAULT_TOKEN/$TOKEN/g" \
    -e "s/$DEFAULT_SLUG/$SLUG/g" \
    includes/class-$DEFAULT_SLUG-settings.php > includes/class-$SLUG-settings.php


SRC=includes/lib/class-$DEFAULT_SLUG-post-type.php
DEST=includes/lib/class-$SLUG-post-type.php
sed -e "s/$DEFAULT_CLASS/$CLASS/g" \
    -e "s/$DEFAULT_TOKEN/$TOKEN/g" \
    -e "s/$DEFAULT_SLUG/$SLUG/g" \
    $SRC > $DEST

SRC=includes/lib/class-$DEFAULT_SLUG-taxonomy.php
DEST=includes/lib/class-$SLUG-taxonomy.php
sed -e "s/$DEFAULT_CLASS/$CLASS/g" \
    -e "s/$DEFAULT_TOKEN/$TOKEN/g" \
    -e "s/$DEFAULT_SLUG/$SLUG/g" \
    $SRC > $DEST

SRC=includes/lib/class-$DEFAULT_SLUG-admin-api.php
DEST=includes/lib/class-$SLUG-admin-api.php
sed -e "s/$DEFAULT_CLASS/$CLASS/g" \
    -e "s/$DEFAULT_TOKEN/$TOKEN/g" \
    -e "s/$DEFAULT_SLUG/$SLUG/g" \
    $SRC > $DEST

if [ "$NEWREPO" == "y" ]; then
	echo "Initialising new git repo..."
	cd ../..
	git init
fi

cd $FOLDER/$SLUG

echo "Complete!"
