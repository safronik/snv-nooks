@echo off

setlocal ENABLEDELAYEDEXPANSION

svn info --show-item last-changed-author > 0.tmp
set /p author="" <0.tmp
del 0.tmp

svn info --show-item last-changed-revision > 0.tmp
set /p revision="" <0.tmp
del 0.tmp

svn log -r COMMITTED > 0.tmp
set changelog=
for /F "delims=" %%x in ('findstr /V "r[1234567890] --- " 0.tmp') do if not X%%x==X set changelog=!changelog!\n%%x
:echo %changelog%
del 0.tmp

curl -X POST --data-urlencode "payload={\"channel\": \"#wordpress-svn\", \"username\": \"Wordpress SVN\", \"text\": \"*New commit*\nAuthor: %author%\nView link: https://plugins.trac.wordpress.org/changeset/%revision%/\n*Changelog*%changelog%\"}" https://hooks.slack.com/services/XXXX/XXXXXXXX

endlocal