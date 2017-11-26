#!/bin/bash 
#################################################
# This script is used to setup users and projects
# for the CICD workshop hosted oon AWS
# Author : Amir Zipory
#################################################
function create_user_projects() {
   local _PROJECTS=
   # create projects 
   for i in `seq 0 2`; do
     if [ $i -lt 10 ]; then
       echo "creating user: user0$i"
       _CMD="sudo htpasswd -b /etc/origin/master/htpasswd user0$i openshift3";
       echo "_CMD: " $_CMD;
       ssh ec2-user@ec2-52-28-24-159.eu-central-1.compute.amazonaws.com "$_CMD";
       oc login -u user0$i -p openshift3
       echo "creating project: explore-0$i"
       oc new-project explore-0$i
       #oc logout
     else
       echo "creating user: user$i"
       _CMD="sudo htpasswd -b /etc/origin/master/htpasswd user$i openshift3";
       ssh ec2-user@ec2-52-28-24-159.eu-central-1.compute.amazonaws.com "$_CMD";
       oc login -u user$i -p openshift3
       echo "creating project: explore-$i"
       oc new-project explore-$i
       #oc logout
     fi
     oc login -u system:admin
   done
}

function clean_up_users() {
   # delete projects
   oc login -u system:admin;
   for i in `seq 0 2`; do
     if [ $i -lt 10 ]; then
       echo "Deleting project explore-0$i";
       oc delete project explore-0$i;
       echo "Deleting user user0$i";
       oc delete user user0$i;
       oc delete identity htpasswd_auth:user0$i;
       _CMD="sudo htpasswd -D /etc/origin/master/htpasswd user0$i"
       ssh ec2-user@ec2-52-28-24-159.eu-central-1.compute.amazonaws.com "$_CMD";
     else
       echo "Deleting project explore-$i";
       oc delete project explore-$i;
       echo "Deleting user user$i";
       oc delete user user$i;
       oc delete identity htpasswd_auth:user$i;
       _CMD="sudo htpasswd -D /etc/origin/master/htpasswd user$i"
       ssh ec2-user@ec2-52-28-24-159.eu-central-1.compute.amazonaws.com "$_CMD";
     fi
   done
}

################################
# MAIN                         #
################################a

#   create_user_projects;
    clean_up_users;
