# Built-In Roles
**Built-In Roles** is any roles defined by mongodb. [Built-in roles documentation](https://docs.mongodb.com/manual/reference/built-in-roles/index.html)

## Create a user with built-in roles

```
db.createUser({
	user: '<user>',
	pwd: '<pwd>',
	roles: [{
		role: '<role>', db: '<db>'
	}]
})
```