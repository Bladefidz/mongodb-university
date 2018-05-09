enron = {}

enron.communication_pair = function () {
	db.messages.aggregate([{
		$unwind: "$headers.To"
	}, {
		$group: {
			_id: {
				id: "$_id",
				from: "$headers.From"
			},
			to: {
				$addToSet: "$headers.To"
			}
		}
	}, {
		$unwind: "$to"
	}, {
		$group: {
			_id: {
				from: "$_id.from",
				to: "$to"
			},
			count: {
				$sum: 1
			}
		}
	}, {
		$sort: {
			count: -1
		}
	}])
}