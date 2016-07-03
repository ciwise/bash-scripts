#!/usr/bin/env bash
# -------------------------------------------------------------
# backup-atlassian-asus.sh
# -------------------------------------------------------------
#
# written by: David L. Whitehurst
# date: January 17, 2016
#
# This script does a database dump of my Confluence and JIRA
# databases and creates the file on my D:drive partition on 
# my ASUS Windows 10 laptop. (Yes, I'm using Windows and
# currently liking it). After the database dumps, I tar and
# gzip the filesystem directories necessary for each product.
# After the files are created I move the files to a secure
# location (not on this machine).
#
# ----


# -------------------------------------------------------------
# Initializations
# -------------------------------------------------------------

echo "############################################################";

NOW=$(date +"%d%b%Y-%H%M")

# -------------------------------------------------------------
# Dumps 
# -------------------------------------------------------------

echo;

# 1. Confluence dump 
# ---

if pg_dump --username=postgres confluence > /d/Backup/PostgreSQL/confluence/confluence-${NOW}.dump
then
   java -jar /d/Backup/google-drive-client-0.0.1-SNAPSHOT.jar --filename=D:\\Backup\\PostgreSQL\\confluence\\confluence-${NOW}.dump upload -p=Atlassian 
   echo;
   echo "1. Confluence database backup completed.";
   echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
   echo;
   echo;
else
   echo;
   echo "ERROR: Postgres dump failed with notification.";
   echo "############################################################";
fi 

# 2. JIRA dump 
# ---

if pg_dump --username=postgres jira > /d/Backup/PostgreSQL/jira/jira-${NOW}.dump
then
   java -jar /d/Backup/google-drive-client-0.0.1-SNAPSHOT.jar --filename=D:\\Backup\\PostgreSQL\\jira\\jira-${NOW}.dump upload -p=Atlassian 
   echo "2. JIRA database backup completed.";
   echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
   echo;
   echo;
else
   echo;
   echo "ERROR: Postgres dump failed with notification.";
   echo "############################################################";
fi 

# -------------------------------------------------------------
# Filesystem copy 
# -------------------------------------------------------------

# 3. Confluence copy 
# ---

if
   cd /c/Program\ Files/Atlassian/Application\ Data/Confluence/backups 
#   tar -cvf /d/Backup/Filesystem/confluence/confluence-data-${NOW}.tar .
FILE=$(ls -t | head -n1)

   cp ${FILE} /d/Backup/Filesystem/confluence/confluence-data-${NOW}.zip
#   cd /d/Backup/
then
   java -jar /d/Backup/google-drive-client-0.0.1-SNAPSHOT.jar --filename=D:\\Backup\\Filesystem\\confluence\\confluence-data-${NOW}.zip upload -p=Atlassian 
   echo "3. Confluence filesystem backup completed.";
   echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
   echo;
   echo;
 else
   echo;
   echo "ERROR: Confluence filesystem backup failed with notification.";
   echo "############################################################";
fi 

# 4. JIRA copy 
# ---

if
   cd /c/Program\ Files/Atlassian/Application\ Data/JIRA/data
   tar -zcvf /d/Backup/Filesystem/jira/jira-data-${NOW}.tar.gz .
   cd /d/Backup/
then
   java -jar /d/Backup/google-drive-client-0.0.1-SNAPSHOT.jar --filename=D:\\Backup\\Filesystem\\jira\\jira-data-${NOW}.tar.gz upload -p=Atlassian 
   echo "4. JIRA filesystem backup completed.";
   echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
   echo;
   echo;
else
   echo;
   echo "ERROR: JIRA filesystem backup failed with notification.";
   echo "############################################################";
fi 

