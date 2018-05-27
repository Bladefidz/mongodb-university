#!/bin/bash

course='M310'
exercise='HW-2.3'
workingDir="$HOME/${course}-${exercise}"
logName="mongo"

host=`hostname -f`

echo "create working folder"
# create working folder
mkdir -p "$workingDir"

echo 'launch mongod'
# launch mongod
mongod --dbpath "$workingDir" --logpath "$workingDir/$logName.log" --bind_ip $host --port 31230 --fork

# wait for mongod to exit
sleep 5

echo "Create new custom rule HRDEPARTMENT"
# Create new custom rule:
# Name 			: HRDEPARTMENT
# Privileges	: 
# 	Can find documents on any collection on the HR database
#	Can insert documents only on HR.employees
#	Can remove users from the HR database
createRoleHRDEPARTMENT="db.createRole({
	role: 'HRDEPARTMENT',
	privileges: [{
		resource: {
			db: 'HR',
			collection: ''
		},
		actions: [
			'find',
			'dropUser'
		]
	}, {
		resource: {
			db: 'HR',
			collection: 'employees'
		},
		actions: [
			'insert'
		]
	}],
	roles: []
})"
mongo admin --port 31230 --eval "$createRoleHRDEPARTMENT"

echo "Create new custom rule MANAGEMENT"
# Create new custom rule:
# Name 			: MANAGEMENT	
# Privileges 	:
# 	Inherits the dbOwner role of the HR database
#	Can insert on all collections in the HR database
createRoleMANAGEMENT="db.createRole({
	role: 'MANAGEMENT',
	privileges: [{
		resource: {
			db: 'HR',
			collection: ''
		},
		actions: [
			'insert'
		]
	}],
	roles: [{
		role: 'dbOwner',
		db: 'HR'
	}]
})" 
mongo admin --port 31230 --eval "$createRoleMANAGEMENT"

echo "Create new custom rule EMPLOYEEPORTAL"
# Create new custom rule:
# Name 			: EMPLOYEEPORTAL	
# Privileges 	:
# 	Can read from HR.employees collection
# 	Can update HR.employees documents
createRoleEMPLOYEEPORTAL="db.createRole({
	role: 'EMPLOYEEPORTAL',
	privileges: [{
		resource: {
			db: 'HR',
			collection: 'employees'
		},
		actions: [
			'find',
			'update'
		]
	}],
	roles: []
})"
mongo admin --port 31230 --eval "$createRoleEMPLOYEEPORTAL"