import pymongo


def remove_orphan(database):
	# Fetch non orphan images
	print "Fetch non orphan images..."
	try:
		cursor = database.albums.find({}, {'images': 1})
	except Exception as e:
		print("Unexpected error:", type(e), e)
	imagesNotOrphan = set()
	for album in cursor:
		for image in album['images']:
			imagesNotOrphan.add(image)
	
	# Inspect non orphan image
	# print imagesNotOrphan
	print "Num non orphan images:", len(imagesNotOrphan)
	
	# Delete orphan images 
	try:
		result = database.images.delete_many({
			'_id': {
				'$nin': list(imagesNotOrphan)}})
		print("num removed: ", result.deleted_count)
	except Exception as e:
		print("Unexpected error:", type(e), e)

	# Count documents in images collection
	try:
		imagesCount = database.images.count()
	except Exception as e:
		print("Unexpected error:", type(e), e)
	print "Num documents in the images collection", imagesCount


connection_string = "mongodb://localhost"
connection = pymongo.MongoClient(connection_string)
database = connection.photos


if __name__ == '__main__':
	remove_orphan(database)