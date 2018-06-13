# Journaling

- To provides durability in the event of a failure, MongoDB uses **write ahead logging** to on-disk journal files.


## Journaling and the WiredTiger Storage Engine

- WiredTiger uses **checkpoint** to recover from the last checkpoint.
- WiredTiger may uses **journaling** if MongoDB exits unexpectedly between checkpoints to recover information after the last checkpoint.


### Journaling Process

- MongoDB configure WiredTiger to use **in-memory buffering** for storing the journal records. All journal records up to 128 kB are buffered.
- WiredTiger syncs the buffered journal records to disk according to the following intervals or conditions:
	- Every 50 milliseconds.
	- Checkpoints on user data every 60 seconds.
	- if the write operation includes a write concern of `{j: true}`, WiredTiger forces a sync of the WiredTiger journal files.
	- Since MongoDB limited journal file size to 100 MB, WiredTiger created a new journal file approximately every 100 MB of data.
- Use `serverStatus` command to returns information on the WiredTiger journal statistics in the **wiredTiger.log** field.