#!/bin/bash -ex

# This script extracts a <div> section from the generated html
# and then assembles a new page with this content.
#
# This output removes the site navigation and other things we do not need
# shell,python,javascript,html all in the same file

cat << EOF > /tmp/extract.py
from bs4 import BeautifulSoup
import sys
soup = BeautifulSoup(file(sys.argv[1]), 'html.parser')
print soup.find(id='database-v1').parent
EOF

SOURCE="publish-docs/api-ref/api-ref-database-v1.html"
TARGET="publish-docs/api-ref/tesora-api-ref-database-v1.html"
WRAPPER="publish-docs/api-ref/tesora-api-ref-database-v1-iframe.html"

cat << HEADER > /tmp/tesoraapi-header
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
   <head>
      <meta content="text/html; charset=UTF-8" http-equiv="content-type"></meta>
      <meta charset="UTF-8"></meta>
      <meta content="IE=edge,chrome=1" http-equiv="X-UA-Compatible"></meta>
      <meta content="width=device-width, initial-scale=1.0" name="viewport"></meta>
      <title>OpenStack API Documentation</title>
      <link href="apiref/css/bootstrap.min.css" rel="stylesheet"></link>
      <link href="apiref/css/main.css" rel="stylesheet" type="text/css"></link>
      <link href="apiref/css/style.css" rel="stylesheet"></link>
      <link href="apiref/css/main.css" rel="stylesheet" type="text/css"></link>
      <link href="apiref/css/bootstrap.min.css" rel="stylesheet"></link>
   </head>
   <body>
HEADER

cat /tmp/tesoraapi-header >> $TARGET
python /tmp/extract.py $SOURCE >> $TARGET

cat << SCRIPT > /tmp/footerscript
<script src="apiref/js/jquery-1.10.2.min.js" type="text/javascript"></script>
<script src="apiref/js/bootstrap.min.js" type="text/javascript"></script>
<script src="apiref/js/api-site.js" type="text/javascript"></script>
</body></html>
SCRIPT

cat /tmp/footerscript >> $TARGET

rm /tmp/footerscript

# lastly, generate iframe wrapper
cat << IFRAME > $WRAPPER
<iframe frameborder="0" height="650" src="http://docs.elasticdb.org/api-ref/$ZUUL_REF/publish-docs/api-ref/tesora-api-ref-database-v1.html" style="" width="100%"> </iframe></p>
IFRAME

# clean up all the files we do not care about
rm publish-docs/api-ref/api-ref*.html
