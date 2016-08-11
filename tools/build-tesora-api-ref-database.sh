#!/bin/bash -ex

cat << EOF > /tmp/extract.py
from bs4 import BeautifulSoup
import sys
soup = BeautifulSoup(file(sys.argv[1]), 'html.parser')
print soup.find(id='database-v1').parent
EOF

SOURCE="publish-docs/api-ref/api-ref-database-v1.html"
TARGET="./publish-docs/api-ref/tesora-api-ref-database-v1.html"

cat << HEADER > /tmp/tesoraapi-header
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
   <head>
      <meta content="text/html; charset=UTF-8" http-equiv="content-type"></meta>
      <meta charset="UTF-8"></meta>
      <meta content="IE=edge,chrome=1" http-equiv="X-UA-Compatible"></meta>
      <meta content="width=device-width, initial-scale=1.0" name="viewport"></meta>
      <title>OpenStack API Documentation</title>
      <link href="http://developer.elasticdb.org/api-ref/apiref/css/bootstrap.min.css" rel="stylesheet"></link>
      <link href="http://developer.elasticdb.org/api-ref/apiref/css/main.css" rel="stylesheet" type="text/css"></link>
      <link href="http://developer.elasticdb.org/api-ref/apiref/css/style.css" rel="stylesheet"></link>
      <link href="http://developer.elasticdb.org/api-ref/apiref/css/main.css" rel="stylesheet" type="text/css"></link>
      <link href="http://developer.elasticdb.org/api-ref/apiref/css/bootstrap.min.css" rel="stylesheet"></link>
   </head>
   <body>
HEADER

cat /tmp/tesoraapi-header >> $TARGET
python /tmp/extract.py $SOURCE >> $TARGET

cat << SCRIPT > /tmp/footerscript
<script src="apiref/js/jquery-1.10.2.min.js" type="text/javascript"></script><script src="apiref/js/bootstrap.min.js" type="text/javascript"></script><script src="apiref/js/api-site.js" type="text/javascript"></script><script type="text/javascript">
                    var _gaq = _gaq || [];
                    _gaq.push(['_setAccount', 'UA-17511903-1']);
                    _gaq.push(['_setDomainName', '.openstack.org']);
                    _gaq.push(['_trackPageview']);
                    (function () {
                    var ga = document.createElement('script');
                    ga.type = 'text/javascript';
                    ga.async = true;
                    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                    var s = document.getElementsByTagName('script')[0];
                    s.parentNode.insertBefore(ga, s);
                    })();
                  </script>
</body></html>
SCRIPT

cat /tmp/footerscript >> ./publish-docs/api-ref/tesora-api-ref-database-v1.html

rm /tmp/footerscript

# clean up all the files we do not care about
rm publish-docs/api-ref/api-ref*.html
