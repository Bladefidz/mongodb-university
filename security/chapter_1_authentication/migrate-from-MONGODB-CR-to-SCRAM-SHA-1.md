# Background
`MongoDB` verson < 3.0 used `MONGDB-CR` authentication by default, while `MongoDB` version >= 3.0 used `SCRAM-SHA-1` authentication by default.

## Migrate
1. Start `mongod`
2. Start `mongo` session
3. To migrate, execute this command:
```
db.adminCommand({authSchemaUpgrade: 1})
```