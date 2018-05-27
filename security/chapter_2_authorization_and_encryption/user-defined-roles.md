# User Defined Roles
Any roles that defined by user by creating and grouping some privileges and resources without or with inherited from built-in roles.

## Create user defined role
```
db.createRole({
	role: <name>,
	privileges: [{
		resource: {
			db: <db>,
			collection: <collection>
		},
		actions: [
			'<privileges>',
			'<privileges>'
		]
	}],
	roles: [{
		role: <role>, db: <db>
	]
})
```