stats = {}
info = {}

if (db != 'm103') {
	print("Only work on m103 database");
	throw "use m103 db before running script";
}

// Info
info.fields = function() {
	print("_id is a serial number for each product in this collection, rarely used in queries but important for internal MongoDB usage")
	print("sku (Stock Keeping Unit) is a randomly generated integer unique to each product - this is commonly used to refer to specific products when updating stock quantities")
    print("name is the name of the product as it appears in the store and on the website")
    print("type is the type of product, with the possible values \"Bundle\", \"Movie\", \"Music\" and \"Software\"")
    print("regularPrice is the regular price of the product, when there is no sale - this price changes every season")
    print("salePrice is the price of a product during a sale - this price changes arbitrarily based on when sales occur")
    print("shippingWeight is the weight of the product in kilograms, ranging between 0.01 and 1.00 - this value is not known for every product in the collection")
}

// stats sku
stats.sku = function(verbose) {
	const cursor = db.products.aggregate([{
		$group: {
			_id: "$sku",
			count: {
				$sum: 1
			}
		}
	}, {
		$group: {
			_id: null,
			count: {
				$sum: 1
			},
			avg: {
				$avg: "$count"
			},
			stdDev: {
				$stdDevPop: "$count"
			}
		}
	}])
	return cursor;
}

// stats name
stats.name = function(verbose) {
	const cursor = db.products.aggregate([{
		$group: {
			_id: "$name",
			count: {
				$sum: 1
			}
		}
	}, {
		$group: {
			_id: null,
			count: {
				$sum: 1
			},
			avg: {
				$avg: "$count"
			},
			stdDev: {
				$stdDevPop: "$count"
			}
		}
	}])
	return cursor;
}

// stats type
stats.type = function(verbose) {
	const cursor = db.products.aggregate([{
		$group: {
			_id: "$type",
			count: {
				$sum: 1
			}
		}
	}, {
		$group: {
			_id: null,
			count: {
				$sum: 1
			},
			avg: {
				$avg: "$count"
			},
			stdDev: {
				$stdDevPop: "$count"
			}
		}
	}])
	return cursor;
}

// stats regularPrice
stats.regularPrice = function(verbose) {
	const cursor = db.products.aggregate([{
		$group: {
			_id: "$regularPrice",
			count: {
				$sum: 1
			}
		}
	}, {
		$group: {
			_id: null,
			count: {
				$sum: 1
			},
			avg: {
				$avg: "$count"
			},
			stdDev: {
				$stdDevPop: "$count"
			}
		}
	}])
	return cursor;
}

// stats salePrice
stats.salePrice = function(verbose) {
	const cursor = db.products.aggregate([{
		$group: {
			_id: "$salePrice",
			count: {
				$sum: 1
			}
		}
	}, {
		$group: {
			_id: null,
			count: {
				$sum: 1
			},
			avg: {
				$avg: "$count"
			},
			stdDev: {
				$stdDevPop: "$count"
			}
		}
	}])
	return cursor;
}

// stats shippingWeight
stats.shippingWeight = function(verbose) {
	const cursor = db.products.aggregate([{
		$group: {
			_id: "$shippingWeight",
			count: {
				$sum: 1
			}
		}
	}, {
		$group: {
			_id: null,
			count: {
				$sum: 1
			},
			avg: {
				$avg: "$count"
			},
			stdDev: {
				$stdDevPop: "$count"
			}
		}
	}])
	return cursor;
}